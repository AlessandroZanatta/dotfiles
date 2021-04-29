{-# LANGUAGE LambdaCase #-}
------------------------------------------------------------------------------
-- |
-- Module: Xmobar.App.Timer
-- Copyright: (c) 2019, 2020 Tomáš Janoušek
-- License: BSD3-style (see LICENSE)
--
-- Maintainer: Tomáš Janoušek <tomi@nomi.cz>
-- Stability: unstable
--
-- Timer coalescing for recurring actions.
--
------------------------------------------------------------------------------

module XmobarAppTimer
    ( doEveryTenthSeconds
    , tenthSeconds
    , withTimer
    ) where

import Control.Concurrent (threadDelay)
import Control.Concurrent.Async (withAsync)
import Control.Concurrent.STM
import Control.Exception
import Control.Monad (forever, forM, guard)
import Data.Foldable (foldrM, for_)
import Data.Int (Int64)
import Data.Map (Map)
import qualified Data.Map as M
import Data.Maybe (isJust, fromJust)
import Data.Time.Clock.POSIX (getPOSIXTime)
import Data.Unique
import System.IO.Unsafe (unsafePerformIO)

type Periods = Map Unique Period

data Tick = Tick (TMVar ()) | UnCoalesce

data Period = Period { rate :: Int64, next :: Int64, tick :: TMVar Tick }

data UnCoalesceException = UnCoalesceException deriving Show
instance Exception UnCoalesceException

{-# NOINLINE periodsVar #-}
periodsVar :: TVar (Maybe Periods)
periodsVar = unsafePerformIO $ newTVarIO Nothing

now :: IO Int64
now = do
    posix <- getPOSIXTime
    return $ floor (10 * posix)

newPeriod :: Int64 -> IO (Unique, Period)
newPeriod r = do
    u <- newUnique
    t <- now
    v <- newEmptyTMVarIO
    let t' = t - t `mod` r
    return (u, Period { rate = r, next = t', tick = v })

-- | Perform a given action every N tenths of a second.
--
-- The timer is aligned (coalesced) with other timers to minimize the number
-- of wakeups and unnecessary redraws. If the action takes too long (one
-- second or when the next timer is due), coalescing is disabled for it and it
-- falls back to periodic sleep.
doEveryTenthSeconds :: Int -> IO () -> IO ()
doEveryTenthSeconds r action =
    doEveryTenthSecondsCoalesced r action `catch` \UnCoalesceException ->
        doEveryTenthSecondsSleeping r action

-- | Perform a given action every N tenths of a second,
-- coalesce with other timers using a given Timer instance.
doEveryTenthSecondsCoalesced :: Int -> IO () -> IO ()
doEveryTenthSecondsCoalesced r action = do
    (u, p) <- newPeriod (fromIntegral r)
    bracket_ (push u p) (pop u) $ forever $ bracket (wait p) done $ const action
    where
        push u p = atomically $ modifyTVar' periodsVar $ \case
            Just periods -> Just $ M.insert u p periods
            Nothing -> throw UnCoalesceException
        pop u = atomically $ modifyTVar' periodsVar $ \case
            Just periods -> Just $ M.delete u periods
            Nothing -> Nothing

        wait p = atomically (takeTMVar $ tick p) >>= \case
            Tick doneVar -> return doneVar
            UnCoalesce -> throwIO UnCoalesceException
        done doneVar = atomically $ putTMVar doneVar ()

-- | Perform a given action every N tenths of a second,
-- making no attempt to synchronize with other timers.
doEveryTenthSecondsSleeping :: Int -> IO () -> IO ()
doEveryTenthSecondsSleeping r action = go
    where go = action >> tenthSeconds r >> go

-- | Sleep for a given amount of tenths of a second.
--
-- (Work around the Int max bound: since threadDelay takes an Int, it
-- is not possible to set a thread delay grater than about 45 minutes.
-- With a little recursion we solve the problem.)
tenthSeconds :: Int -> IO ()
tenthSeconds s | s >= x = do threadDelay (x * 100000)
                             tenthSeconds (s - x)
               | otherwise = threadDelay (s * 100000)
               where x = (maxBound :: Int) `div` 100000

-- | Start the timer coordination thread and perform a given IO action (this
-- is meant to surround the entire xmobar execution), terminating the timer
-- thread afterwards.
--
-- Additionally, if the timer thread fails, individual
-- 'doEveryTenthSecondsCoalesced' invocations that are waiting to be
-- coordinated by it are notified to fal back to periodic sleeping.
--
-- The timer thread _will_ fail immediately when running in a non-threaded
-- RTS.
withTimer :: (IO () -> IO ()) -> IO a -> IO a
withTimer pauseRefresh action =
    withAsync (timerThread `finally` cleanup) $ const action
    where
        timerThread = do
            atomically $ writeTVar periodsVar $ Just M.empty
            timerLoop pauseRefresh

        cleanup = atomically $ readTVar periodsVar >>= \case
            Just periods -> do
                for_ periods unCoalesceTimer'
                writeTVar periodsVar Nothing
            Nothing -> return ()

timerLoop :: (IO () -> IO ()) -> IO ()
timerLoop pauseRefresh = forever $ do
    tNow <- now
    (toFire, tMaybeNext) <- atomically $ do
        periods <- fromJust <$> readTVar periodsVar
        let toFire = timersToFire tNow periods
        let periods' = advanceTimers tNow periods
        let tMaybeNext = nextFireTime periods'
        writeTVar periodsVar $ Just periods'
        return (toFire, tMaybeNext)
    pauseRefresh $ do
        -- To avoid multiple refreshes, pause refreshing for up to 1 second,
        -- fire timers and wait for them to finish (update their text).
        -- Those that need more time (e.g. weather monitors) will be dropped
        -- from timer coalescing and will fall back to periodic sleep.
        timeoutVar <- registerDelay $ case tMaybeNext of
            Just tNext -> fromIntegral ((tNext - tNow) `max` 10) * 100000
            Nothing -> 1000000
        fired <- fireTimers toFire
        timeouted <- waitForTimers timeoutVar fired
        unCoalesceTimers timeouted
    delayUntilNextFire

advanceTimers :: Int64 -> Periods -> Periods
advanceTimers t = M.map advance
    where
        advance p | next p <= t = p { next = t - t `mod` rate p + rate p }
                  | otherwise = p

timersToFire :: Int64 -> Periods -> [(Unique, Period)]
timersToFire t periods = [ (u, p) | (u, p) <- M.toList periods, next p <= t ]

nextFireTime :: Periods -> Maybe Int64
nextFireTime periods
    | M.null periods = Nothing
    | otherwise = Just $ minimum [ next p | p <- M.elems periods ]

fireTimers :: [(Unique, Period)] -> IO [(Unique, TMVar ())]
fireTimers toFire = atomically $ forM toFire $ \(u, p) -> do
    doneVar <- newEmptyTMVar
    putTMVar (tick p) (Tick doneVar)
    return (u, doneVar)

waitForTimers :: TVar Bool -> [(Unique, TMVar ())] -> IO [Unique]
waitForTimers timeoutVar fired = atomically $ do
    timeoutOver <- readTVar timeoutVar
    dones <- forM fired $ \(u, doneVar) -> do
        done <- isJust <$> tryReadTMVar doneVar
        return (u, done)
    guard $ timeoutOver || all snd dones
    return [u | (u, False) <- dones]

-- | Handle slow timers (drop and signal them to stop coalescing).
unCoalesceTimers :: [Unique] -> IO ()
unCoalesceTimers timers = atomically $ do
    periods <- fromJust <$> readTVar periodsVar
    periods' <- foldrM unCoalesceTimer periods timers
    writeTVar periodsVar $ Just periods'

unCoalesceTimer :: Unique -> Periods -> STM Periods
unCoalesceTimer u periods = do
    unCoalesceTimer' (periods M.! u)
    return $ u `M.delete` periods

unCoalesceTimer' :: Period -> STM ()
unCoalesceTimer' p = do
    _ <- tryTakeTMVar (tick p)
    putTMVar (tick p) UnCoalesce

delayUntilNextFire :: IO ()
delayUntilNextFire = do
    Just periods <- readTVarIO periodsVar
    let tMaybeNext = nextFireTime periods
    tNow <- now
    delayVar <- case tMaybeNext of
        Just tNext -> do
            -- Work around the Int max bound: threadDelay takes an Int, we can
            -- only sleep for so long, which is okay, we'll just check timers
            -- sooner and sleep again.
            let maxDelay = (maxBound :: Int) `div` 100000
                delay = (tNext - tNow) `min` fromIntegral maxDelay
                delayUsec = fromIntegral delay * 100000
            registerDelay delayUsec
        Nothing -> newTVarIO False
    atomically $ do
        delayOver <- readTVar delayVar
        periods' <- fromJust <$> readTVar periodsVar
        let tMaybeNext' = nextFireTime periods'
        -- Return also if a new period is added (it may fire sooner).
        guard $ delayOver || tMaybeNext /= tMaybeNext'
