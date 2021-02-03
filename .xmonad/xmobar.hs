----------------------------------------------
-- __   __                _                 --
-- \ \ / /               | |                --
--  \ V / _ __ ___   ___ | |__   __ _ _ __  --
--   > < | '_ ` _ \ / _ \| '_ \ / _` | '__| --
--  / . \| | | | | | (_) | |_) | (_| | |    -- 
-- /_/ \_\_| |_| |_|\___/|_.__/ \__,_|_|    -- 
---------------------------------------------- 

import Xmobar
import Data.Optional
import Data.Data
import Text.Printf

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

--------------------------------------------------------------------------------
-- SYMBOLS-LOGOS
--------------------------------------------------------------------------------

-- Font 1
archLogo        = "<fn=1>\xF303 </fn>"
cpuLogo         = "<fn=1>\xF85A </fn>"
ramLogo         = "<fn=1>\xE266 </fn>"

-- Font 2
arrowRight      = "<fn=2>\xE0B0</fn>" -- use font 2, fixed the default y position
arrowLeft       = "<fn=2>\xE0B2</fn>" -- use font 2, fixed the default y position
emptyArrowRight = "<fn=2>\xE0B1</fn>" -- use font 2, fixed the default y position
emptyArrowLeft  = "<fn=2>\xE0B3</fn>" -- use font 2, fixed the default y position

--------------------------------------------------------------------------------
-- POWERLINE-LIKE TEMPLATE
--------------------------------------------------------------------------------

data ArrowType = LeftArrow
  | RightArrow
  | EmptyLeftArrow
  | EmptyRightArrow
  deriving Eq

-- Create the arrow based on passed stuff 
doArrow arrowType content bg fg afterColor =
  case arrowType of
    LeftArrow       -> arrowTemplate bg afterColor arrowLeft ++ template 
    RightArrow      -> template ++ arrowTemplate bg afterColor arrowRight
    EmptyLeftArrow  -> arrowTemplate afterColor bg emptyArrowLeft ++ template
    EmptyRightArrow -> template ++ arrowTemplate afterColor bg emptyArrowRight
  where
    template = printf "<fc=%s,%s:0>%s</fc>" fg bg content
    arrowTemplate = printf "<fc=%s,%s>%s</fc>" 

-- Wrap with an action the given string
wrapWithAction :: String -> String -> String
wrapWithAction toWrap action = printf "<action=%s>%s</action>" action toWrap


powerlineTemplate :: String
powerlineTemplate = 
  (wrapWithAction (doArrow RightArrow ("   " ++ archLogo ++ "  ") "#434343" "white" myBgColor) "xdotool key super+p") 
  ++ "    %UnsafeStdinReader%"
  ++ "}%date%{"
  ++ "%microphone%"
  ++ doArrow LeftArrow "%internet%%bluetooth% " "#a0a0a0" "#222222" "#a0a0a0"
  ++ doArrow LeftArrow 
        "  %cpu%  " 
        "#5a5a5a" "#eeeeee" "#a0a0a0"
  ++ doArrow EmptyLeftArrow 
        "  %memory%  " 
        "#5a5a5a" "#eeeeee" "#999999"
  ++ doArrow LeftArrow 
        "  %battery%  " 
        "#4a4a4a" "#eeeeee" "#5a5a5a"

--------------------------------------------------------------------------------
-- CONFIGS
--------------------------------------------------------------------------------

config :: Config
config = defaultConfig { 

   -- Appearance
     font = myFont
   , additionalFonts = myAdditionalFonts
   , textOffsets  = xftAlign -- align xft fonts correctly
   , bgColor      = myBgColor
   , fgColor      = myFgColor
   , position     = myPosition
   , border       = myBorder
   , borderColor  = myBorderColor

   -- Layout
   , sepChar  = mySepChar
   , alignSep = myAlignSep
   , template = powerlineTemplate
   
   -- General behavior
   , lowerOnStart     = False   -- send to bottom of window stack on start
   , hideOnStart      = False   -- start with window unmapped (hidden)
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
        
        , Run $ Com "/home/kalex/.xmonad/scripts/internetconnection" [] "internet" 10
        , Run $ Com "/home/kalex/.xmonad/scripts/bluetoothstatus" [] "bluetooth" 10
        , Run $ Com "/home/kalex/.xmonad/scripts/battery" [] "battery" 10 
        
        , Run $ Com "/home/kalex/.xmonad/scripts/microphone" ["#A0A0A0"] "microphone" 10 

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
