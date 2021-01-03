import XMonad
import XMonad.Config.Kde

-- to shift and float windows
import qualified XMonad.StackSet as W
import Control.Monad (liftM2)

-- default desktopConfig
import XMonad.Config.Desktop 

-- avoidStruts lives here
import XMonad.Hooks.ManageDocks

-- spawnPipe is here
import XMonad.Util.Run

-- stuff to manage xmobar
import XMonad.Hooks.DynamicLog

-- to set the WMName to something else, otherwise clion is unhappy and refuses to work
import XMonad.Hooks.SetWMName

-- Allow spacing (gaps) to be displayed around windows (definitly more beauty this way)
import XMonad.Layout.Spacing

-- Remove window borders if they aren't needed
import XMonad.Layout.NoBorders (smartBorders)

-- Needed to make plasmashell work properly (notifications, system tray)
import XMonad.Hooks.ManageHelpers

-- Needed for the workspace names
import XMonad.Actions.DynamicWorkspaces

-- For keybindings
import qualified Data.Map as M
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

-- Data.List provides isPrefixOf isSuffixOf and isInfixOf
import Data.List

--------------------------------------------------------------------------------
-- KEYBINDS
--------------------------------------------------------------------------------

myApplicationLauncher = "/home/kalex/.config/rofi/bin/launcher_colorful"

myKeyBindings conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, xK_p), spawn myApplicationLauncher)       -- bind M-p to the application launcher
      , ((modm .|. shiftMask, xK_s), spawn "spectacle") -- take a screenshot with M-shift-s
      -- , ((modm, xK_f), sendMessage $ Toggle FULL)    -- to fix
    ]

-- Add myKeyBindings to the default keybindings and save into myKeys
myKeys = \c -> myKeyBindings c `M.union` keys kde4Config c
 
-- Define wheter the window focus should follow the mouse or not 
myFocusFollowsMouse = True

--------------------------------------------------------------------------------
-- AESTHETICS
--------------------------------------------------------------------------------

-- Gaps around and between windows
-- Changes only seem to apply if I log out then in again
-- Dimensions are given as (Border top-bottom-right-left)
mySpacing = spacingRaw True             -- Only for >1 window
                       (Border 0 5 5 5) -- Size of screen edge gaps
                       True             -- Enable screen edge gaps
                       (Border 5 5 5 5) -- Size of window gaps
                       True             -- Enable window gaps

-- Define the border width. 1 should be the default
myBorderWidth :: Dimension
myBorderWidth = 1

myNormalBorderColor, myFocusedBorderColor :: [Char]
myNormalBorderColor = "#7c7c7c"
myFocusedBorderColor = "#6093ac"


myLayoutHook 
  = avoidStruts 
  $ mySpacing 
  -- $ mkToggle (NOBORDERS ?? FULL ?? EOT) -- to fix to switch instantly to fullscreen layout  
  $ smartBorders ( layoutHook desktopConfig )

--------------------------------------------------------------------------------
-- WORKSPACE
--------------------------------------------------------------------------------

-- Define my workspaces (statically)
myWorkspaces = ["<fn=1>\xE745 </fn>","<fn=1>\xFCB5 </fn>", "<fn=1>\xE235 </fn>", "<fn=1>\xFB6E </fn>", "<fn=1>\xFB75 </fn>"] ++ map show [6..9]

-- Define the manageHook to use
myManageHook = composeAll . concat $
    [  
      -- This entry is used to make plasmashell work with xmonad
      [ className =? "plasmashell" <&&> isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_NOTIFICATION" --> doIgnore
          , isDialog --> doFloat
          , isFullscreen --> doFullFloat]
      
      -- Either by classname or title, use the infix 'cause i'm laxy!


      -- Shift to
      -- By classname
      , [ fmap ( c `isInfixOf` ) className --> viewShift (myWorkspaces !! 0) | c <- myWs0Class]
      , [ fmap ( c `isInfixOf` ) className --> viewShift (myWorkspaces !! 1) | c <- myWs1Class]
      , [ fmap ( c `isInfixOf` ) className --> viewShift (myWorkspaces !! 2) | c <- myWs2Class]
      , [ fmap ( c `isInfixOf` ) className --> viewShift (myWorkspaces !! 3) | c <- myWs3Class]
      , [ fmap ( c `isInfixOf` ) className --> viewShift (myWorkspaces !! 4) | c <- myWs4Class]
      -- By title
      , [ fmap ( t `isInfixOf` ) title     --> viewShift (myWorkspaces !! 0) | t <- myWs0Title]
      , [ fmap ( t `isInfixOf` ) title     --> viewShift (myWorkspaces !! 1) | t <- myWs1Title]
      , [ fmap ( t `isInfixOf` ) title     --> viewShift (myWorkspaces !! 2) | t <- myWs2Title]
      , [ fmap ( t `isInfixOf` ) title     --> viewShift (myWorkspaces !! 3) | t <- myWs3Title]
      , [ fmap ( t `isInfixOf` ) title     --> viewShift (myWorkspaces !! 4) | t <- myWs4Title]

      -- Ignored
      , [ fmap ( c `isInfixOf` ) className --> doIgnore | c <- myIgnoreClass]
      , [ fmap ( t `isInfixOf` ) title     --> doIgnore | t <- myIgnoreTitle]

      -- Floats
      , [ fmap ( c `isInfixOf` ) className --> doFloat | c <- myFloatsClass] 
      , [ fmap ( t `isInfixOf` ) title     --> doFloat | t <- myFloatsTitle]
    ]
  where viewShift = doF . liftM2 (.) W.greedyView W.shift
        myWs0Class   = ["firefox"]
        myWs1Class   = ["code-oss", "pycharm", "clion", "webstorm", "phpstorm", "okular"]
        myWs2Class   = []
        myWs3Class   = []
        myWs4Class   = ["Chromium"]
        
        myWs0Title   = []
        myWs1Title   = ["Ghidra", "Lutris"]
        myWs2Title   = ["League"]
        myWs3Title   = ["Discord", "Teams", "Telegram"]
        myWs4Title   = []

        myFloatsClass     = []
        myFloatsTitle     = ["KCalc"]        

        myIgnoreClass     = []
        myIgnoreTitle     = ["win0"] -- jetbrains ide opens this when starting

--------------------------------------------------------------------------------
-- STARTUP
--------------------------------------------------------------------------------

-- Some appplication, as CLion, refuses to work with xmonad.
-- Simply take them think this is not xmonad fixes everything!
myStartupHook = setWMName "LG3D"

--------------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------------

main = do

  -- Create a xmobar instance and keep a pipe open
  xmob <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
  xmonad kde4Config
    { 
    modMask = mod4Mask -- use the Windows button as mod
    , manageHook = manageHook kde4Config <+> myManageHook -- Start up applications as specified in myManageHook
    , workspaces = myWorkspaces
    , borderWidth = myBorderWidth
    , startupHook = myStartupHook
    , layoutHook = myLayoutHook
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , logHook = dynamicLogWithPP $ -- xmobar properties
        xmobarPP 
          {
          ppOutput = hPutStrLn xmob                         -- where to write
          , ppCurrent = xmobarColor "yellow" ""             -- color of selected workspace
          , ppLayout = const ""                             -- layout string to show
          , ppTitle = xmobarColor "#6093ac" "" . shorten 40 -- Title of the focused window
          , ppSep = "    "                                  -- separator between things
          }
    , keys = myKeys
    , focusFollowsMouse  = myFocusFollowsMouse
    }
