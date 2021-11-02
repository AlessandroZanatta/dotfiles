module Bluetooth where

----------------------------------------
-- BLUETOOTH PLUGIN
----------------------------------------

import Control.Concurrent.Async
import DBus
import DBus.Client
import Data.IORef
import Data.Maybe
import System.FilePath ((</>))
import Text.Regex.Posix
import Utils
import Xmobar

btIcon = "\xF294" `withFont` 1

btGetPairedDevices :: IO [String]
btGetPairedDevices = do
  client <- connectSystem
  let objectPath = objectPath_ "/org/bluez/hci0"
  let interfaceName = interfaceName_ "org.freedesktop.DBus.Introspectable"
  let memberName = memberName_ "Introspect"
  let callDestination = Just $ busName_ "org.bluez"

  reply <-
    call_
      client
      (methodCall objectPath interfaceName memberName)
        { methodCallDestination = callDestination
        }

  let unwrapped_reply = fromJust $ fromVariant (head (methodReturnBody reply)) :: String

  let matches = (unwrapped_reply =~ "(dev_[0-9A-F]{2}_[0-9A-F]{2}_[0-9A-F]{2}_[0-9A-F]{2}_[0-9A-F]{2}_[0-9A-F]{2})" :: [[String]])
  let pairedDevices =
        if null matches
          then []
          else firsts matches

  disconnect client
  return pairedDevices

doEveryTenthSeconds :: Int -> IO () -> IO ()
doEveryTenthSeconds r action = go
  where
    go = action >> tenthSeconds r >> go

btWithRefreshPairedDevices :: Int -> (IORef [String] -> IO ()) -> IO ()
btWithRefreshPairedDevices r action = do
  paired <- newIORef =<< btGetPairedDevices
  let refresh = atomicWriteIORef paired =<< btGetPairedDevices
  concurrently_ (doEveryTenthSeconds r refresh) (action paired)

btCheckConnection :: Client -> String -> IO Bool
btCheckConnection client device = do
  let objectPath = objectPath_ ("/org/bluez/hci0" </> device)
  let interfaceName = interfaceName_ "org.bluez.Device1"
  let memberName = memberName_ "Connected"
  let callDestination = Just $ busName_ "org.bluez"

  Right reply <-
    getProperty
      client
      (methodCall objectPath interfaceName memberName)
        { methodCallDestination = callDestination
        }

  return $ fromJust (fromVariant reply)

-- Check if any device in the list is
btAnyDeviceConnected :: Client -> [String] -> IO Bool
btAnyDeviceConnected client [] = return False
btAnyDeviceConnected client devices = do
  isConnected <- btCheckConnection client (head devices)
  if isConnected
    then return True
    else btAnyDeviceConnected client (drop 1 devices)

btStatusText :: IORef [String] -> IO String
btStatusText pairedDevicesRef = do
  client <- connectSystem
  pairedDevices <- readIORef pairedDevicesRef
  anyPaired <- btAnyDeviceConnected client pairedDevices
  let statusText =
        if anyPaired
          then " " ++ doArrow EmptyLeftArrow (" " ++ btIcon) "#A0A0A0" "#222222" "#777777"
          else ""

  disconnect client
  return statusText

data MyBluetooth = MyBluetooth Int
  deriving (Read, Show)

-- Implementation HIGHLY inspired by https://github.com/jaor/xmobar/blob/master/src/Xmobar/Plugins/Date.hs
instance Exec MyBluetooth where
  rate (MyBluetooth r) = r
  alias (MyBluetooth _) = "mybt"

  -- Update the actual list of paired devices every 10 minutes as it requires to
  -- run a regex against ~4kB of data (and I don't really pair new stuff often)
  start (MyBluetooth r) cb =
    btWithRefreshPairedDevices (600 * 10) $ \paired ->
      doEveryTenthSeconds r $ btStatusText paired >>= cb
