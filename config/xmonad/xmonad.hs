{-# LANGUAGE FlexibleContexts #-}

---------------------------------------------
--  __   ____  __                       _  --
--  \ \ / /  \/  |                     | | --
--   \ V /| \  / | ___  _ __   __ _  __| | --
--    > < | |\/| |/ _ \| '_ \ / _` |/ _` | --
--   / . \| |  | | (_) | | | | (_| | (_| | --
--  /_/ \_\_|  |_|\___/|_| |_|\__,_|\__,_| --
---------------------------------------------

import Control.Monad (liftM2)
import Data.Function (on)
import Data.List
import qualified Data.Map as M
import Data.Ratio
import Graphics.X11.ExtraTypes.XF86
import Microphone
import System.IO
import Text.Printf
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.WindowMenu
import qualified XMonad.DBus as D
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.XPropManage
import qualified XMonad.Layout.IndependentScreens as IS
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing
import XMonad.Operations
import qualified XMonad.StackSet as W
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

--------------------------------------------------------------------------------
-- HOME AND OTHER DIRECTORIES
--------------------------------------------------------------------------------

homeDir, dotfilesDir, scriptsDir, configDir, xmonadDir, wallpapersDir :: [Char]
homeDir = "/home/kalex/"
dotfilesDir = homeDir ++ "dotfiles/"
scriptsDir = dotfilesDir ++ "scripts/"
configDir = homeDir ++ ".config/"
xmonadDir = configDir ++ "xmonad/"
wallpapersDir = dotfilesDir ++ "misc/wallpapers/"

--------------------------------------------------------------------------------
-- KEYBINDS
--------------------------------------------------------------------------------

myApplicationLauncher, myScreenshotUtility, myScreenlocker, myTerminal :: [Char]
myApplicationLauncher = configDir ++ "rofi/launchers/text/launcher.sh"
myScreenshotUtility = "flameshot gui"
myScreenlocker = "lock" 
myTerminal = "kitty"
myChangeOutputVolume = scriptsDir ++ "change_output_volume.sh "
myChangeInputVolume = scriptsDir ++ "change_input_volume.sh "
myChangeBrightness = scriptsDir ++ "change_brightness.sh "

myKeyBindings conf@XConfig {XMonad.modMask = modm} =
  M.fromList
    [ 
      -- Spawn of many utilities
      ((modm, xK_p), spawn myApplicationLauncher),                                      -- Mod-p                        --> Open application launcher
      ((modm, xK_Return), spawn myTerminal),                                            -- Mod+Enter                    --> Open new terminal 
      ((modm .|. shiftMask, xK_s), spawn myScreenshotUtility),                          -- Mod+Shift+S                  --> Take a screenshot
      ((modm .|. shiftMask, xK_l), spawn myScreenlocker),                               -- Mod+Shift+L                  --> Lock screen
      ((modm, xK_b), spawn "polybar-msg cmd toggle"),                                   -- Mod-B                        --> Toggle polybar
      
      -- Screen brightness 
      ((0, xF86XK_MonBrightnessUp), spawn $ myChangeBrightness ++ "-inc 5"),            -- XF86MonBrightnessUp          --> +5% brightness
      ((0, xF86XK_MonBrightnessDown), spawn $ myChangeBrightness ++ "-dec 5"),          -- XF86MonBrightnessUp          --> -5% brightness

      -- Volume management
      ((0, xF86XK_AudioRaiseVolume), spawn $ myChangeOutputVolume ++ "5%+"),            -- XF86AudioRaiseVolume         --> +5% volume
      ((0, xF86XK_AudioLowerVolume), spawn $ myChangeOutputVolume ++ "5%-"),            -- XF86AudioLowerVolume         --> -5% volume
      ((0, xF86XK_AudioMute), spawn $ myChangeOutputVolume ++ "toggle"),                -- XF86AudioMute                --> Toggle output volume 

      ((shiftMask, xF86XK_AudioRaiseVolume), spawn $ myChangeInputVolume ++ "5%+"),     -- Shift+XF86AudioRaiseVolume   --> +5% microphone volume
      ((shiftMask, xF86XK_AudioLowerVolume), spawn $ myChangeInputVolume ++ "5%-"),     -- Shift+XF86AudioLowerVolume   --> -5% microphone volume
      ((modm .|. shiftMask, xK_m), spawn $ myChangeInputVolume ++ "toggle"),            -- Mod-Shift-M                  --> Toggle microphone volume 


      -- Switch between workspaces with arrows
      ((modm, xK_Right), nextWS),
      ((modm, xK_Left), prevWS),

      -- Layout management
      ((modm, xK_f), sendMessage $ Toggle FULL),                                        -- Mod-f                --> Switch to fullscreen layout
      ((modm .|. controlMask, xK_h), sendMessage $ IncMasterN 1),                       -- Mod-Ctrl-h           --> Increase windows in the master pane
      ((modm .|. controlMask, xK_l), sendMessage $ IncMasterN $ -1),                    -- Mod-Ctrl-l           --> Decrease windows in the master pane
      
      -- Misc
      ((modm, xK_q), spawn $ "cd " ++ xmonadDir ++ " && make restart"),                 -- Mod-q                --> Re-build and restart xmonad and xmobar
      ((modm .|. shiftMask, xK_Up), spawn "systemctl suspend"),                         -- Mod-Shift-Up         --> Suspend to RAM
      ((modm .|. shiftMask, xK_Down), spawn "systemctl hibernate")                      -- Mod-Shift-Down       --> Hibernate to DISK
    ]

-- Add myKeyBindings to the default keybindings and save into myKeys
myKeys c = myKeyBindings c `M.union` keys def c

-- Define whether the window focus should follow the mouse or not
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

--------------------------------------------------------------------------------
-- AESTHETICS
--------------------------------------------------------------------------------

-- Gaps around and between windows
-- Changes only seem to apply if I log out then in again
-- Dimensions are given as (Border top-bottom-right-left)
mySpacing = smartSpacingWithEdge 4
  -- spacingRaw
  --   True -- Only for >1 window
  --   (Border 0 5 5 5) -- Size of screen edge gaps
  --   True -- Enable screen edge gaps
  --   (Border 5 5 5 5) -- Size of window gaps
  --   True -- Enable window gaps

-- Define the border width. 1 should be the default
myBorderWidth :: Dimension
myBorderWidth = 1

-- Border colors
myNormalBorderColor, myFocusedBorderColor :: [Char]
myNormalBorderColor = "#1c2022"
myFocusedBorderColor = "#606060"

myLayout =
  tiling
    ||| Mirror tiling
  where
    -- default tiling algorithm partitions the screen into two panes
    tiling = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 3 / 5

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

myLayoutHook =
  avoidStruts $
    mySpacing $
      smartBorders $
        mkToggle
          (NOBORDERS ?? FULL ?? EOT) -- switch to fullscreen layout
          myLayout

--------------------------------------------------------------------------------
-- WORKSPACE
--------------------------------------------------------------------------------

-- Define my workspaces (statically)
-- myWorkspaces = ["1: %{T1}\xE1B4%{T-}", "2: %{T1}\xE1EF%{T-}", "3: %{T1}\xE0AA%{T-}", "4: %{T1}\xE1E9%{T-}", "5: %{T1}\xE0AA%{T-}", "6", "7", "8", "9"]

myWorkspaces = clickable ["1:%{T1}\xf269 %{T-}", "2:%{T1}\xe62b %{T-}", "3:%{T1}\xf668 %{T-}", "4:%{T1}\xfb6e %{T-}", "5:%{T1}\xf11b %{T-}", "6", "7", "8", "9"]
  where
    clickable l =
      [ "%{A1:xdotool key super+" ++ show n ++ ":}" ++ ws ++ "%{A}"
        | (i, ws) <- zip [1 .. 9] l,
          let n = i
      ]

-- Define the manageHook to use
myManageHook =
  composeAll . concat $
    [ -- Start SpeedCrunch at the center of the screen, resized to be small enough
      [title =? "SpeedCrunch" --> doRectFloat (W.RationalRect 0.25 0.25 0.5 0.5)],
      -- Either by classname or title, use the infix 'cause i'm lazy!

      -- Shift to
      -- By classname
      [fmap (c `isInfixOf`) className --> viewShift (myWorkspaces !! 0) | c <- myWs0Class],
      [fmap (c `isInfixOf`) className --> viewShift (myWorkspaces !! 1) | c <- myWs1Class],
      [fmap (c `isInfixOf`) className --> viewShift (myWorkspaces !! 2) | c <- myWs2Class],
      [fmap (c `isInfixOf`) className --> viewShift (myWorkspaces !! 3) | c <- myWs3Class],
      [fmap (c `isInfixOf`) className --> viewShift (myWorkspaces !! 4) | c <- myWs4Class],
      -- By title
      [fmap (t `isInfixOf`) title --> viewShift (myWorkspaces !! 0) | t <- myWs0Title],
      [fmap (t `isInfixOf`) title --> viewShift (myWorkspaces !! 1) | t <- myWs1Title],
      [fmap (t `isInfixOf`) title --> viewShift (myWorkspaces !! 2) | t <- myWs2Title],
      [fmap (t `isInfixOf`) title --> viewShift (myWorkspaces !! 3) | t <- myWs3Title],
      [fmap (t `isInfixOf`) title --> viewShift (myWorkspaces !! 4) | t <- myWs4Title],
      -- Ignored
      [fmap (c `isInfixOf`) className --> doIgnore | c <- myIgnoreClass],
      [fmap (t `isInfixOf`) title --> doIgnore | t <- myIgnoreTitle],
      -- Floats
      [fmap (c `isInfixOf`) className --> doFloat | c <- myFloatsClass],
      [fmap (t `isInfixOf`) title --> doFloat | t <- myFloatsTitle],
      [fmap (c `isInfixOf`) className --> doCenterFloat | c <- myCenterFloatsClass],
      [fmap (t `isInfixOf`) title --> doCenterFloat | t <- myCenterFloatsTitle]
    ]
  where
    viewShift = doF . liftM2 (.) W.greedyView W.shift
    myWs0Class = ["firefox"]
    myWs1Class = ["code-oss", "pycharm", "clion", "webstorm", "phpstorm"]
    myWs2Class = ["okular"]
    myWs3Class = []
    myWs4Class = ["Chromium"]

    myWs0Title = []
    myWs1Title = []
    myWs2Title = ["Ghidra"]
    myWs3Title = ["Discord", "Teams", "Telegram"]
    myWs4Title = ["Teeworlds"]

    myFloatsClass = []
    myFloatsTitle = []

    myIgnoreClass = []
    myIgnoreTitle = ["win0"] -- jetbrains ide opens this when starting
    myCenterFloatsClass = []
    myCenterFloatsTitle = ["KCalc"]

--------------------------------------------------------------------------------
-- STARTUP
--------------------------------------------------------------------------------

myStartupHook = do
  -- Some applications, such as CLion, refuse to work with xmonad.
  -- Simply make them think this is not xmonad fixes everything!
  -- setWMName "LG3D"
  spawn "autorandr -c"
  spawn $ scriptsDir ++ "handle-polybar"
  spawnOnce "flameshot"
  spawnOnce $ scriptsDir ++ "locker"
  spawnOnce "picom"
  spawnOnce "mailspring"
  spawnOnce "parcellite -n"
  -- spawnOnce "nm-applet"
  spawnOnce "dunst"
  spawn $ "feh --bg-fill " ++ wallpapersDir ++ "neon.png"

--------------------------------------------------------------------------------
-- POLYBAR
--------------------------------------------------------------------------------

myLogHook dbus =
  def
    { ppOutput = D.send dbus,
      ppSep = "    ", -- separator between things
      ppTitle = shorten 40, -- Title of the focused window
      ppCurrent = wrap "%{F#61afef}" "%{F-}", -- color of selected workspace
      ppLayout = const "", -- layout string to show
      ppVisible = wrap "%{F#A3BE8C}" "%{F-}"
    }

--------------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------------

main :: IO ()
main = do
  -- Connect to DBus
  dbus <- D.connect
  -- Request access (needed when sending messages)
  D.requestAccess dbus

  xmonad $
    docks $
      def
        { modMask = mod4Mask,
          manageHook = myManageHook <+> manageHook def,
          workspaces = myWorkspaces,
          borderWidth = myBorderWidth,
          startupHook = myStartupHook <+> startupHook def,
          layoutHook = myLayoutHook,
          normalBorderColor = myNormalBorderColor,
          focusedBorderColor = myFocusedBorderColor,
          keys = myKeys,
          logHook = dynamicLogWithPP (myLogHook dbus),
          focusFollowsMouse = myFocusFollowsMouse,
          clickJustFocuses = myClickJustFocuses
        }
