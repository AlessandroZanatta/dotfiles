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
import System.IO
import Text.Printf
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.UrgencyHook
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
import XMonad.Layout.Grid
import XMonad.Operations
import qualified XMonad.StackSet as W
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import System.Environment

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
myApplicationLauncher = configDir ++ "rofi/launchers/colorful/launcher.sh"
myScreenshotUtility = "flameshot gui"
myScreenlocker = "lock" 
myTerminal = "kitty"
myChangeOutputVolume = scriptsDir ++ "change_output_volume.sh "
myChangeInputVolume = scriptsDir ++ "change_input_volume.sh "
myChangeBrightness = scriptsDir ++ "change_brightness.sh "
myChangeMusicVolume = scriptsDir ++ "change_music_volume.sh "
myDashboard = "eww open-many blur_full weather profile quote search_full vpn-icon home_dir screenshot power_full reboot_full lock_full logout_full hibernate_full updates --toggle"

myKeyBindings conf@XConfig {XMonad.modMask = modm} =
  M.fromList
    [ 
      -- Spawn of many utilities
      ((modm, xK_p), spawn myApplicationLauncher),                                      -- Mod-p                        --> Open application launcher
      ((modm, xK_Return), spawn myTerminal),                                            -- Mod+Enter                    --> Open new terminal 
      ((modm .|. shiftMask, xK_s), spawn myScreenshotUtility),                          -- Mod+Shift+S                  --> Take a screenshot
      ((modm .|. shiftMask, xK_l), spawn myScreenlocker),                               -- Mod+Shift+L                  --> Lock screen
      ((modm, xK_b), spawn "polybar-msg cmd toggle"),                                   -- Mod-B                        --> Toggle polybar
      ((modm, xK_d), spawn myDashboard),                                                -- Mod-D                        --> Spawn eww dashboard
      
      -- Screen brightness 
      ((0, xF86XK_MonBrightnessUp), spawn $ myChangeBrightness ++ "-inc 5"),            -- XF86MonBrightnessUp          --> +5% brightness
      ((0, xF86XK_MonBrightnessDown), spawn $ myChangeBrightness ++ "-dec 5"),          -- XF86MonBrightnessUp          --> -5% brightness

      -- Volume management
      ((0, xF86XK_AudioRaiseVolume), spawn $ myChangeOutputVolume ++ "5%+"),            -- XF86AudioRaiseVolume         --> +5% volume
      ((0, xF86XK_AudioLowerVolume), spawn $ myChangeOutputVolume ++ "5%-"),            -- XF86AudioLowerVolume         --> -5% volume
      ((0, xF86XK_AudioMute), spawn $ myChangeOutputVolume ++ "toggle"),                -- XF86AudioMute                --> Toggle output volume 

      ((shiftMask, xF86XK_AudioRaiseVolume), spawn $ myChangeInputVolume ++ "1%+"),     -- Shift+XF86AudioRaiseVolume   --> +1% microphone volume
      ((shiftMask, xF86XK_AudioLowerVolume), spawn $ myChangeInputVolume ++ "1%-"),     -- Shift+XF86AudioLowerVolume   --> -1% microphone volume
      ((modm .|. shiftMask, xK_m), spawn $ myChangeInputVolume ++ "toggle"),            -- Mod-Shift-M                  --> Toggle microphone volume 
      
      -- Music controls
      ((0, xF86XK_AudioPlay), spawn "playerctl play-pause"),                            -- XF86AudioPlay                --> Toggle music
      ((0, xF86XK_AudioPrev), spawn "playerctl previous"),                              -- XF86AudioPrev                --> Previous song
      ((0, xF86XK_AudioNext), spawn "playerctl next"),                                  -- XF86AudioNext                --> Next song
      ((controlMask, xF86XK_AudioRaiseVolume), spawn $ myChangeMusicVolume ++ "+0.05"), -- Ctrl+XF86AudioRaiseVolume    --> Raise music volume
      ((controlMask, xF86XK_AudioLowerVolume), spawn $ myChangeMusicVolume ++ "-0.05"), -- Ctrl+XF86AudioLowerVolume    --> Lower music volume
      

      -- Switch between workspaces with arrows
      ((modm, xK_Right), nextWS),
      ((modm, xK_Left), prevWS),

      -- Layout management
      ((modm, xK_f), sendMessage $ Toggle FULL),                                        -- Mod-f                --> Switch to fullscreen layout

      -- These two are quite "buggy", as they make it difficult to understand when a workspace is tiling vs Mirror tiling (check myLayout definition)
      -- ((modm .|. controlMask, xK_h), sendMessage $ IncMasterN 1),                       -- Mod-Ctrl-h           --> Increase windows in the master pane
      -- ((modm .|. controlMask, xK_l), sendMessage $ IncMasterN $ -1),                    -- Mod-Ctrl-l           --> Decrease windows in the master pane
      
      -- Misc
      ((modm, xK_q), spawn "xmonad --restart"),                                         -- Mod-q                --> Re-build and restart xmonad and xmobar
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
myNormalBorderColor = "#606060"
myFocusedBorderColor = "#c0c0c0"

myLayout =
  tiling
    ||| Mirror tiling
    ||| Grid
  where
    -- default tiling algorithm partitions the screen into two panes
    tiling = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 5 / 100

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
      [fmap (c `isInfixOf`) className --> doShift (myWorkspaces !! 0) | c <- myWs0Class],
      [fmap (c `isInfixOf`) className --> doShift (myWorkspaces !! 1) | c <- myWs1Class],
      [fmap (c `isInfixOf`) className --> doShift (myWorkspaces !! 2) | c <- myWs2Class],
      [fmap (c `isInfixOf`) className --> doShift (myWorkspaces !! 3) | c <- myWs3Class],
      [fmap (c `isInfixOf`) className --> doShift (myWorkspaces !! 4) | c <- myWs4Class],
      -- By title
      [fmap (t `isInfixOf`) title --> doShift (myWorkspaces !! 0) | t <- myWs0Title],
      [fmap (t `isInfixOf`) title --> doShift (myWorkspaces !! 1) | t <- myWs1Title],
      [fmap (t `isInfixOf`) title --> doShift (myWorkspaces !! 2) | t <- myWs2Title],
      [fmap (t `isInfixOf`) title --> doShift (myWorkspaces !! 3) | t <- myWs3Title],
      [fmap (t `isInfixOf`) title --> doShift (myWorkspaces !! 4) | t <- myWs4Title],
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
    myWs0Class = ["firefox"]
    myWs1Class = ["code-oss"]
    myWs2Class = ["okular"]
    myWs3Class = []
    myWs4Class = []

    myWs0Title = []
    myWs1Title = []
    myWs2Title = ["Ghidra"]
    myWs3Title = ["Discord", "Teams", "Telegram"]
    myWs4Title = ["DDNet"]

    myFloatsClass = []
    myFloatsTitle = []

    myIgnoreClass = []
    myIgnoreTitle = []
    myCenterFloatsClass = []
    myCenterFloatsTitle = []

--------------------------------------------------------------------------------
-- STARTUP
--------------------------------------------------------------------------------

myStartupHook = do
  spawnOnce "flameshot" -- screenshot utility daemon
  spawnOnce $ scriptsDir ++ "locker.sh" -- start automatic locking after a certain period of inactivity
  spawnOnce "picom" -- start compositor
  spawnOnce "mailspring" -- start mail client 
  spawnOnce "parcellite -n" -- start clipboard manager
  spawnOnce "kitty --title 'Bitwarden ssh keys unlock' env SSH_AUTH_SOCK=\"$XDG_RUNTIME_DIR/ssh-agent.socket\" /usr/local/bin/bw-ssh-add.py" -- unlock of ssh keys with password saved on bitwarden
  -- spawnOnce "nm-applet"
  spawnOnce "dunst" -- start dunst notification daemon
  spawnOnce "eww daemon" -- start eww daemon 
  spawnOnce $ "xss-lock -- lock" -- make sure to lock screen when suspending/hibernating
  spawn "autorandr -c" -- launch autorandr to make sure monitor(s) geometry is updated
  spawn $ scriptsDir ++ "handle-polybar.sh" -- launch polybar (or more if multiple monitors are detected)
  spawn $ "feh --bg-fill " ++ wallpapersDir ++ "neon.png" -- set wallpaper
  spawn $ "kill $(ps aux | grep '[b]ash .*/scripts/updates.sh' | awk '{print $2}'); " ++ scriptsDir ++ "updates.sh" -- dashboard data refresh

--------------------------------------------------------------------------------
-- POLYBAR
--------------------------------------------------------------------------------

myLogHook dbus =
  def
    { ppOutput = D.send dbus,
      ppSep = "    ", -- separator between things
      ppTitle = shorten 50, -- Title of the focused window, shortened to fit my (smallest) screen
      ppCurrent = wrap "%{F#61afef}" "%{F-}", -- color of selected workspace
      ppLayout = const "", -- layout string to show
      ppVisible = wrap "%{F#A3BE8C}" "%{F-}", -- color of the workspace selected on other monitors (if any)
      ppUrgent = wrap "%{F#BF616A}" "%{F-}"
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
    withUrgencyHook NoUrgencyHook $
      docks $
        ewmh def
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
