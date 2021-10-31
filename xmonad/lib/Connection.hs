module Connection where

----------------------------------------
-- CONNECTION STATE PLUGIN
----------------------------------------

import Xmobar
import Utils

import Text.Regex.Posix
import Data.List
import System.FilePath ((</>))

netBaseDir            = "/sys/class/net"      -- Base directory of adapters
netEthernetAdapter    = "enp2s0"              -- Cable adapter
netWirelessAdapter    = "wlp3s0"              -- Wireless adapter
netStateFile          = "operstate"           -- Status of the adapter
netStateUp            = "up"                  -- When adapter is being used, status is "up"...
netStateDown          = "down"                -- ...otherwise it is "down"
netWirelessSignalFile = "/proc/net/wireless"  -- File containing some information, including the wireless link strength

-- Icons
netCableIcon        = "\xF700"  `withFont` 1
netWirelessIcon     = "\xF1EB " `withFont` 1
netNoConnectionIcon = "\xF127 " `withFont` 1

-- Get wireless signal strength parsing netWirelessSignalFile
getWirelessSignalStrength :: String -> IO String
getWirelessSignalStrength interface = do
    stats <- readFile netWirelessSignalFile
    let interfaceLine = head $ filter (isInfixOf interface) (lines stats) -- fetch correct line
    return (head (interfaceLine =~ ("^" ++ interface ++ ": [0-9]{4}[ ]{3}([0-9]{2})") :: [[String]]) !! 1) -- magical regexp to return the correct value

networkStatusText :: IO String
networkStatusText = do
    wirelessState <- readAlphaNumFile (netBaseDir </> netWirelessAdapter </> netStateFile)
    cableState    <- readAlphaNumFile (netBaseDir </> netEthernetAdapter </> netStateFile)
    statusText    <- if wirelessState == netStateUp
                     then do
                         signalStrength <- getWirelessSignalStrength netWirelessAdapter
                         return (netWirelessIcon ++ " " ++ signalStrength ++ " dB") :: IO String
                     else if cableState == netStateUp
                         then return netCableIcon
                         else return netNoConnectionIcon

    return (" " ++ statusText)

data MyNetwork = MyNetwork Int
    deriving (Read, Show)

instance Exec MyNetwork where
    rate  (MyNetwork r) = r
    alias (MyNetwork _) = "mynet"
    run   (MyNetwork r) = networkStatusText
