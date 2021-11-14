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
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.WindowMenu
import XMonad.Config.Desktop
import XMonad.Config.Kde
import qualified XMonad.DBus as D
import XMonad.Hooks.DynamicLog
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
-- DEFINED FUNCTIONS
--------------------------------------------------------------------------------

toggleMic :: IO ()
toggleMic = do spawn micToggleMuteCommand

--------------------------------------------------------------------------------
-- KEYBINDS
--------------------------------------------------------------------------------

myApplicationLauncher = "~/.config/polybar/grayblocks/scripts/launcher.sh"

xmonadDir = "$HOME/.xmonad"

myScreenshotUtility = "flameshot gui"

myKeyBindings conf@XConfig {XMonad.modMask = modm} =
  M.fromList
    [ ((modm, xK_p), spawn myApplicationLauncher), -- Mod-p            --> Open application launcher
      ((modm .|. shiftMask, xK_s), spawn myScreenshotUtility), -- Mod+Shift+S      --> Take a screenshot
      ((modm, xK_f), sendMessage $ Toggle FULL), -- Mod-f            --> Switch to fullscreen layout
      ((modm, xK_q), spawn ("cd " ++ xmonadDir ++ " && make restart")), -- Mod-q            --> Re-build and restart xmonad and xmobar
      ((modm .|. shiftMask, xK_m), liftIO toggleMic), -- Mod-Shift-M      --> Toggle mic mute
      ((modm .|. shiftMask, xK_Up), spawn "systemctl suspend"), -- Mod-Shift-Up     --> Suspend to RAM
      ((modm .|. shiftMask, xK_Down), spawn "systemctl hibernate"), -- Mod-Shift-Down   --> Hibernate to DISK
      ((modm, xK_Right), nextWS),
      ((modm, xK_Left), prevWS)
    ]

-- Add myKeyBindings to the default keybindings and save into myKeys
myKeys c = myKeyBindings c `M.union` keys kde4Config c

-- Define wheter the window focus should follow the mouse or not
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
mySpacing =
  spacingRaw
    True -- Only for >1 window
    (Border 0 5 5 5) -- Size of screen edge gaps
    True -- Enable screen edge gaps
    (Border 5 5 5 5) -- Size of window gaps
    True -- Enable window gaps

-- Define the border width. 1 should be the default
myBorderWidth :: Dimension
myBorderWidth = 1

myNormalBorderColor, myFocusedBorderColor :: [Char]
myNormalBorderColor = "#7c7c7c"
myFocusedBorderColor = "darkorange"

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
-- xE1F7 wireguard
-- Define my workspaces (statically)
myWorkspaces = ["1: %{T1}\xE1B4%{T-}", "2: %{T1}\xE1EF%{T-}", "3: %{T1}\xE0AA%{T-}", "4: %{T1}\xE1E9%{T-}", "5: %{T1}\xE0AA%{T-}", "6", "7", "8", "9"]

-- myWorkspaces = clickable ["1: <fc=yellow><fn=1>\xF79F </fn></fc>", "2: <fc=#33ff00><fn=1>\xF120 </fn></fc>", "3: <fc=#ffff00><fn=1>\xF668 </fn></fc>", "4: <fc=#289ed9><fn=1>\xF2C6 </fn></fc>", "5: <fn=1>\xFB75 </fn>", "6", "7", "8", "9"]
--   where
--     clickable l =
--       [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>"
--         | (i, ws) <- zip [1 .. 9] l,
--           let n = i
--       ]

-- Define the manageHook to use
myManageHook =
  composeAll . concat $
    [ -- This entry is used to make plasmashell work with xmonad
      [ className =? "plasmashell" <&&> isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_NOTIFICATION" --> doIgnore,
        isDialog --> doFloat,
        isFullscreen --> doFullFloat
      ],
      -- KDE system tray support (NOTICE: this works because there is a single plasma object started with plasmawindowed!)
      [className =? "plasmawindowed" --> doIgnore],
      -- Start SpeedCrunch at the center of the screen, resized to be small enough
      [title =? "SpeedCrunch" --> doRectFloat (W.RationalRect 0.25 0.25 0.5 0.5)],
      -- Either by classname or title, use the infix 'cause i'm laxy!

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
    myWs2Title = ["Lutris", "League", "Ghidra", "Steam"]
    myWs3Title = ["Discord", "Teams", "Telegram", "Signal"]
    myWs4Title = ["Cantata"]

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
  -- Some appplication, as CLion, refuses to work with xmonad.
  -- Simply make them think this is not xmonad fixes everything!
  setWMName "LG3D"
  spawn "/home/kalex/.xmonad/handle-polybar"

--------------------------------------------------------------------------------
-- XMOBAR
--------------------------------------------------------------------------------

myLogHook dbus =
  def
    { ppOutput = D.send dbus,
      ppSep = "    ", -- separator between things
      ppTitle = shorten 30, -- Title of the focused window
      ppLayout = const "" -- layout string to show
      -- ppCurrent = wrap "<box type=Bottom width=2 color=red>" "</box>", -- color of selected workspace
      -- ppTitleSanitize = xmobarStrip,
      -- ppVisible = wrap "<box type=Bottom width=2 color=#73dae6>" "</box>"
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
    ( kde4Config
        { modMask = mod4Mask, -- use the Windows button as mod
          manageHook = manageHook kde4Config <+> myManageHook, -- Start up applications as specified in myManageHook
          workspaces = myWorkspaces,
          borderWidth = myBorderWidth,
          startupHook = myStartupHook,
          layoutHook = myLayoutHook,
          normalBorderColor = myNormalBorderColor,
          focusedBorderColor = myFocusedBorderColor,
          keys = myKeys,
          logHook = dynamicLogWithPP (myLogHook dbus),
          focusFollowsMouse = myFocusFollowsMouse,
          clickJustFocuses = myClickJustFocuses
        }
    )