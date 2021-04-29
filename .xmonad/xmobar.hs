----------------------------------------------
-- __   __                _                 --
-- \ \ / /               | |                --
--  \ V / _ __ ___   ___ | |__   __ _ _ __  --
--   > < | '_ ` _ \ / _ \| '_ \ / _` | '__| --
--  / . \| | | | | | (_) | |_) | (_| | |    -- 
-- /_/ \_\_| |_| |_|\___/|_.__/ \__,_|_|    -- 
---------------------------------------------- 

import Xmobar
import Data.Data
import Text.Printf
import System.IO
import Data.Char
import Data.List
import Text.Regex.Posix
import DBus
import DBus.Client
import Data.Maybe (fromJust)
import Sound.ALSA.Mixer

--------------------------------------------------------------------------------
-- CONFIGURATION STUFF
--------------------------------------------------------------------------------

myFont            = "xft:Hack:size=9:bold:antialias=true"
myAdditionalFonts = ["xft:mononoki Nerd Font:pixelsize=16:antialias=true:hinting=true", "xft:mononoki Nerd Font:pixelsize=20:Regular:antialias=true" ]
xftAlign          = [14, 15]    -- some xft fonts are not correctly aligned

myBgColor         = "#141a21"   -- background color
myFgColor         = "#dddddd"   -- text color
myPosition        = Top         -- where the bar should be at
myBorder          = NoBorder    -- define where the border should be at (if any) 
myBorderColor     = "#646464"   -- color of the border (ignored if myBorder is "NoBorder")

mySepChar         =  "%"        -- delineator between plugin names and straight text
myAlignSep        = "}{"        -- separator between left-right alignment

configDir         = "/home/kalex/.xmonad/"  -- where this file and xmonad.hs are
scriptsDir        = configDir ++ "scripts/" -- where my xmobar scripts are in

--------------------------------------------------------------------------------
-- USEFUL FUNCTIONS
--------------------------------------------------------------------------------

-- Take each first element of each sublist in the given list
firsts [] = []
firsts [(x:xs)] = [x]
firsts ((x:xs):xss) = x: firsts xss

-- Read file composed of alphanumeric characters
readAlphaNumFile :: String -> IO String
readAlphaNumFile filename = do
    filecontent <- readFile(filename)
    return (filter isAlphaNum filecontent) :: IO String

-- Wrap the given string with the given font number tag
withFont :: String -> Int -> String
withFont logo fontNum = 
  "<fn=" ++ show fontNum ++ ">" ++ logo ++ "</fn>"

-- Wrap with an action the given string
wrapWithAction :: String -> String -> String
wrapWithAction toWrap action = printf "<action=%s>%s</action>" action toWrap

-- Wrap with a color the given string
wrapWithColors :: String -> String -> String -> String
wrapWithColors toWrap fgColor bgColor = printf "<fc=%s,%s>%s</fc>" fgColor bgColor toWrap

--------------------------------------------------------------------------------
-- USER DEFINED PLUGINS 
--------------------------------------------------------------------------------

----------------------------------------
-- BATTERY PLUGIN
----------------------------------------

batteryBaseDir    = "/sys/class/power_supply/BAT0/" -- where the following files are located 
fullEnergyFile    = "energy_full"                   -- energy when battery is full
currEnergyFile    = "energy_now"                    -- current energy of the battery
statusFile        = "status"                        -- status file to read from 
dischargingStatus = ["Discharging"]                 -- possible file contents of the statusFile, indicating the battery is discharging

-- Battery symbols
battery0        = "\xF582" `withFont` 1
battery10       = "\xF579" `withFont` 1
battery20       = "\xF57A" `withFont` 1
battery30       = "\xF57B" `withFont` 1
battery40       = "\xF57C" `withFont` 1
battery50       = "\xF57D" `withFont` 1
battery60       = "\xF57E" `withFont` 1
battery70       = "\xF57F" `withFont` 1
battery80       = "\xF580" `withFont` 1
battery90       = "\xF581" `withFont` 1
battery100      = "\xF578" `withFont` 1
batteryCharging = "\xF583" `withFont` 1


getBatteryIcon :: Int -> String
getBatteryIcon charge
  | charge  < 10  = battery0
  | charge  < 20  = battery10
  | charge  < 30  = battery20
  | charge  < 40  = battery30
  | charge  < 50  = battery40
  | charge  < 60  = battery50
  | charge  < 70  = battery60
  | charge  < 80  = battery70
  | charge  < 90  = battery80
  | charge  < 100 = battery90
  | charge == 100 = battery100 
  | otherwise     = "Something's wrong!"


batteryStatusText :: IO String
batteryStatusText = do
    energyNow     <- readAlphaNumFile (batteryBaseDir ++ currEnergyFile)
    energyFull    <- readAlphaNumFile (batteryBaseDir ++ fullEnergyFile)
    chargingState <- readAlphaNumFile (batteryBaseDir ++ statusFile)
    let percentageEnergy = round ((read energyNow :: Float) / (read energyFull :: Float) * 100)
    
    let endingText = " " ++ show(percentageEnergy) ++ "%"
    let chosenIcon = if chargingState `elem` dischargingStatus
                     then getBatteryIcon percentageEnergy
                     else batteryCharging

    return (chosenIcon ++ endingText) :: IO String

data MyBattery = MyBattery Int
    deriving (Read, Show)

instance Exec MyBattery where
    rate  (MyBattery r) = r
    alias (MyBattery _) = "mybat"
    run   (MyBattery r) = batteryStatusText 

----------------------------------------
-- CONNECTION STATE PLUGIN
----------------------------------------

netBaseDir            = "/sys/class/net/"     -- Base directory of adapters
netEthernetAdapter    = "enp2s0"              -- Cable adapter
netWirelessAdapter    = "wlp3s0"              -- Wireless adapter
netStateFile          = "/operstate"          -- Status of the adapter
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
    return ((interfaceLine =~ ("^" ++ interface ++ ": [0-9]{4}[ ]{3}([0-9]{2})") :: [[String]]) !! 0 !! 1) -- magical regexp to return the correct value

networkStatusText :: IO String
networkStatusText = do
    wirelessState <- readAlphaNumFile (netBaseDir ++ netWirelessAdapter ++ netStateFile)
    cableState    <- readAlphaNumFile (netBaseDir ++ netEthernetAdapter ++ netStateFile)
    statusText    <- if wirelessState == netStateUp
                     then do
                         signalStrength <- getWirelessSignalStrength netWirelessAdapter
                         return (netWirelessIcon ++ " " ++ signalStrength) :: IO String
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

----------------------------------------
-- BLUETOOTH PLUGIN
----------------------------------------

btIcon = "\xF294" `withFont` 1

btGetPairedDevices :: Client -> IO [String]
btGetPairedDevices client = do
    let objectPath      = objectPath_ "/org/bluez/hci0"
    let interfaceName   = interfaceName_ "org.freedesktop.DBus.Introspectable"
    let memberName      = memberName_ "Introspect"
    let callDestination = Just $ busName_ "org.bluez"

    reply <- call_ client (methodCall objectPath interfaceName memberName) 
          { methodCallDestination = callDestination }
  
    let unwrapped_reply = fromJust $ fromVariant (methodReturnBody reply !! 0) :: String 

    let matches = (unwrapped_reply =~ ("(dev_[0-9A-F]{2}_[0-9A-F]{2}_[0-9A-F]{2}_[0-9A-F]{2}_[0-9A-F]{2}_[0-9A-F]{2})") :: [[String]])
    if null matches
        then return []
        else return $ firsts matches

btCheckConnection :: Client -> String -> IO Bool
btCheckConnection client device = do
    let objectPath      = objectPath_ ("/org/bluez/hci0/" ++ device)
    let interfaceName   = interfaceName_ "org.bluez.Device1"
    let memberName      = memberName_ "Connected"
    let callDestination = Just $ busName_ "org.bluez"
    
    Right reply <- getProperty client (methodCall objectPath interfaceName memberName) 
          { methodCallDestination = callDestination }
    
    return $ fromJust (fromVariant reply)

-- Check if any device in the list is 
btAnyDeviceConnected :: Client -> [String] -> IO Bool
btAnyDeviceConnected client [] = do return False
btAnyDeviceConnected client devices = do
    isConnected <- btCheckConnection client (devices !! 0)
    if isConnected 
        then return True
        else btAnyDeviceConnected client (drop 1 devices)


btStatusText :: IO String
btStatusText = do
    client <- connectSystem
    pairedDevices <- btGetPairedDevices client
   
    anyPaired <- btAnyDeviceConnected client pairedDevices
    let statusText = if anyPaired
                         then (" " ++ (doArrow EmptyLeftArrow (" " ++ btIcon) "#A0A0A0" "#222222" "#777777"))
                         else ""

    disconnect client
    return statusText
    

data MyBluetooth = MyBluetooth Int
    deriving (Read, Show)

instance Exec MyBluetooth where
    rate  (MyBluetooth r) = r
    alias (MyBluetooth _) = "mybt"
    run   (MyBluetooth r) = btStatusText 

----------------------------------------
-- MICROPHONE PLUGIN
----------------------------------------

-- Playback file (https://stackoverflow.com/questions/35772758/alsa-how-to-programmatically-find-if-a-device-is-busy-in-use-using-it-name-and/39260690)
micMicrophoneRunningFile = "/proc/asound/card0/pcm0c/sub0/status"
micClosedState = "closed"

-- Icons
micIconOn  = " \xF86B " `withFont` 1
micIconOff = " \xF86C " `withFont` 1 

micIsNotMuted :: IO Bool
micIsNotMuted =
    withMixer "default" $ \mixer -> do 
        Just control <- getControlByName mixer "Capture"
        let Just captureSwitch = capture $ switch control
        Just sw <- getChannel FrontLeft captureSwitch
        return sw

micIsNotRunning :: IO Bool
micIsNotRunning = do
    status <- readAlphaNumFile micMicrophoneRunningFile
    return $ status == micClosedState

micStatusText :: IO String
micStatusText = do
    isNotRunning  <- micIsNotRunning
    isNotMuted <- micIsNotMuted
    let stateString = if isNotRunning
                          then ""
                          else if isNotMuted
                              then (micIconOn  `wrapWithAction` "pactl set-source-mute 1 1")
                              else ((wrapWithColors micIconOff "darkred" "#DDDDDD") `wrapWithAction` "pactl set-source-mute 1 0")
    
    -- Formatting stuff 
    if stateString == ""
        then return (stateString ++ (wrapWithColors arrowLeft "#a0a0a0" "#222222"))
        else return ((doArrow LeftArrow stateString "#DDDDDD" "#222222" myBgColor) ++ (wrapWithColors arrowLeft "#a0a0a0" "#DDDDDD"))

data MyMicrophone = MyMicrophone Int
    deriving (Read, Show)

instance Exec MyMicrophone where
    rate  (MyMicrophone r) = r
    alias (MyMicrophone _) = "mymic"
    run   (MyMicrophone r) = micStatusText

--------------------------------------------------------------------------------
-- SYMBOLS-LOGOS
--------------------------------------------------------------------------------

-- Font 1
archLogo        = "\xF303 " `withFont` 1
cpuLogo         = "\xF85A " `withFont` 1
ramLogo         = "\xE266 " `withFont` 1
calendarLogo    = "\xF133 " `withFont` 1

-- Font 2
arrowRight      = "\xE0B0" `withFont` 2
arrowLeft       = "\xE0B2" `withFont` 2
emptyArrowRight = "\xE0B1" `withFont` 2
emptyArrowLeft  = "\xE0B3" `withFont` 2

--------------------------------------------------------------------------------
-- POWERLINE-LIKE TEMPLATE
--------------------------------------------------------------------------------

data ArrowType = LeftArrow
  | RightArrow
  | EmptyLeftArrow
  | EmptyRightArrow
  | NoArrow
  deriving Eq

-- Create the arrow based on passed stuff
doArrow :: ArrowType -> String -> String -> String -> String -> String 
doArrow arrowType content bg fg afterColor =
  case arrowType of
    LeftArrow       -> arrowTemplate bg afterColor arrowLeft ++ template 
    RightArrow      -> template ++ arrowTemplate bg afterColor arrowRight
    EmptyLeftArrow  -> arrowTemplate afterColor bg emptyArrowLeft ++ template
    EmptyRightArrow -> template ++ arrowTemplate afterColor bg emptyArrowRight
    NoArrow         -> template
  where
    template = printf "<fc=%s,%s:0>%s</fc>" fg bg content
    arrowTemplate = printf "<fc=%s,%s>%s</fc>" 

-- Powerline-like Template
powerlineTemplate :: String
powerlineTemplate = 
  (doArrow RightArrow ("   " ++ archLogo ++ "  ") "#434343" "white" myBgColor) `wrapWithAction` "xdotool key super+p"
  ++ "    %UnsafeStdinReader%"
  ++ "}%date%{"
  ++ "%mymic%"
  ++ doArrow NoArrow 
        "%mynet%%mybt% " 
        "#a0a0a0" "#222222" "#a0a0a0"
  ++ doArrow LeftArrow 
        "  %cpu%  " 
        "#5a5a5a" "#eeeeee" "#a0a0a0"
  ++ doArrow EmptyLeftArrow 
        "  %memory%  " 
        "#5a5a5a" "#eeeeee" "#999999"
  ++ doArrow LeftArrow 
        "  %mybat%  " 
        "#4a4a4a" "#eeeeee" "#5a5a5a"

--------------------------------------------------------------------------------
-- CONFIGS
--------------------------------------------------------------------------------

config :: Config
config = defaultConfig { 

   -- Appearance
     font             = myFont
   , additionalFonts  = myAdditionalFonts
   , textOffsets      = xftAlign -- align xft fonts correctly
   , bgColor          = myBgColor
   , fgColor          = myFgColor
   , position         = myPosition
   , border           = myBorder
   , borderColor      = myBorderColor

   -- Layout
   , sepChar          = mySepChar
   , alignSep         = myAlignSep
   , template         = powerlineTemplate
   
   -- General behavior
   , lowerOnStart     = False   -- do NOT send to bottom of window stack on start
   , hideOnStart      = False   -- do NOT start with window unmapped (hidden)
   , allDesktops      = True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest     = False   -- choose widest display (multi-monitor)
   , persistent       = True    -- enable/disable hiding (True = disabled)

   -- Plugins
   , commands = 
        [ 
        -- This line tells xmobar to read input from stdin. That's how we
        -- get the information that xmonad is sending it for display.

        Run UnsafeStdinReader

        -- Cpu monitor
        , Run $ Cpu          [ "--template" , cpuLogo ++ "<total>%" ] 10

        -- Memory usage monitor
        , Run $ Memory       [ "--template" , ramLogo ++ "<usedratio>%" ] 10
        
        -- Run my scripts
        , Run $ MyMicrophone 10
        , Run $ MyBluetooth 50        , Run $ Com (scriptsDir ++ "microphone") ["#A0A0A0"] "microphone" 10

        , Run $ MyBattery 30
        , Run $ MyNetwork 50
          
        -- Time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run $ Date           "<fc=#dddddd>%F (%a) %T</fc>" "date" 10
        ]
   }

--------------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------------

main :: IO ()
main = xmobar config
