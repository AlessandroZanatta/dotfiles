----------------------------------------------
-- __   __                _                 --
-- \ \ / /               | |                --
--  \ V / _ __ ___   ___ | |__   __ _ _ __  --
--   > < | '_ ` _ \ / _ \| '_ \ / _` | '__| --
--  / . \| | | | | | (_) | |_) | (_| | |    -- 
-- /_/ \_\_| |_| |_|\___/|_.__/ \__,_|_|    -- 
---------------------------------------------- 

import Xmobar

import Utils
import Battery
import Connection
import Bluetooth
import Microphone
import VPN

--------------------------------------------------------------------------------
-- CONFIGURATION STUFF
--------------------------------------------------------------------------------

myFont            = "xft:Hack:size=9:bold:antialias=true"
myAdditionalFonts = ["xft:mononoki Nerd Font:pixelsize=16:antialias=true:hinting=true"
                    , "xft:mononoki Nerd Font:pixelsize=20:Regular:antialias=true"
                    , "xft:mononoki Nerd Font:pixelsize=18:Regular:antialias=true" 
                    ]
xftAlign          = [14, 15, 15]    -- some xft fonts are not correctly aligned

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
-- SYMBOLS-LOGOS
--------------------------------------------------------------------------------

-- Font 1
archLogo        = "\xF303 " `withFont` 1
cpuLogo         = "\xF85A " `withFont` 1
ramLogo         = "\xE266 " `withFont` 1
calendarLogo    = "\xF133 " `withFont` 1

--------------------------------------------------------------------------------
-- POWERLINE-LIKE TEMPLATE
--------------------------------------------------------------------------------

-- Powerline-like Template
powerlineTemplate :: String
powerlineTemplate =
  doArrow RightArrow ("   " ++ archLogo ++ "  ") "#434343" "white" myBgColor `wrapWithAction` "xdotool key super+p"
  ++ "    %UnsafeStdinReader%"
  ++ "}%date%{"
  ++ "%mymic%"
  ++ doArrow NoArrow 
        " %myvpn%"
        "#a0a0a0" "#222222" ""
  ++ doArrow EmptyLeftArrow
        "%mynet%%mybt% "
        "#a0a0a0" "#222222" "#777777"
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
        , Run $ MyMicrophone myBgColor 10
        , Run $ MyBluetooth 50
        , Run $ MyBattery 30
        , Run $ MyNetwork 30
        , Run $ VPN ["HomeVPN"] 100

        -- Time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run $ Date           "<fc=#dddddd>%F (%a) <fc=#ee9a00>%H:%M</fc></fc>" "date" 10
        ]
   }

--------------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------------

main :: IO ()
main = xmobar config
