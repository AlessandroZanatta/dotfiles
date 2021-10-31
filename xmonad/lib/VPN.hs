module VPN where

import Xmobar
import Utils

import Control.Monad (filterM)
import System.Directory (getDirectoryContents, doesFileExist)
import System.FilePath ((</>))

connected    = "\xf838 " `withFont` 3
disconnected = "\xf839 " `withFont` 3

data VPN = VPN [String] Int
    deriving (Read, Show)

instance Exec VPN where
    rate  (VPN _ r) = r
    alias (VPN _ _) = "myvpn"
    run   (VPN d _) = vpnStatusText d

vpnStatusText :: [String] -> IO String
vpnStatusText d = do
    vpnlist <- validDevs d
    return $ if null vpnlist
                 then wrapWithColors disconnected "darkred" "#a0a0a0"
                 else connected

validDevs :: [String] -> IO [String]
validDevs d = getDirectoryContents "/sys/class/net" >>= filterM isValidDev
    where isValidDev x | x `elem` d = doesFileExist ("/sys/class/net" </> x </> "operstate")
                       | otherwise  = return False
