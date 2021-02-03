import XMonad
import XMonad.Config.Kde

-- to shift and float windows
import qualified XMonad.StackSet as W
import Control.Monad (liftM2)

-- default desktopConfig
import XMonad.Config.Desktop 

-- avoidStruts lives here
import XMonad.Hooks.ManageDocks

-- spawnPipe
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

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

-- Used to create rationals with %
import Data.Ratio

-- Move and resize floating window
import XMonad.Hooks.XPropManage


-- Additional keys (like XF85AudioPlay, ...)
import Graphics.X11.ExtraTypes.XF86

--------------------------------------------------------------------------------
-- KEYBINDS
--------------------------------------------------------------------------------

myApplicationLauncher = "/home/kalex/.config/rofi/bin/launcher_colorful"

myKeyBindings conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, xK_p)                       , spawn myApplicationLauncher)                                -- Mod-p                  --> open application launcher
      , ((modm .|. shiftMask, xK_s)       , spawn "spectacle")                                          -- Mod+Shift+S            --> take a screenshot
      , ((modm, xK_f)                     , sendMessage $ Toggle FULL)                                  -- Mod-f                  --> switch to fullscreen layout
      , ((0, xF86XK_AudioPlay)            , spawn "/home/kalex/.xmonad/scripts/mpc_wrap toggle")        -- XF86AudioPlay          --> MPD: Toggle pause/play
      , ((0, xF86XK_AudioPrev)            , spawn "/home/kalex/.xmonad/scripts/mpc_wrap prev")          -- XF86AudioPrev          --> MPD: Go to previous song
      , ((0, xF86XK_AudioNext)            , spawn "/home/kalex/.xmonad/scripts/mpc_wrap next")          -- XF86AudioNext          --> MPD: Go to next song
      , ((modm, xF86XK_AudioLowerVolume)  , spawn "mpc volume -5")                                      -- XF86AudioLowerVolume   --> MPD: lower volume
      , ((modm, xF86XK_AudioRaiseVolume)  , spawn "mpc volume +5")                                      -- XF86AudioRaiseVolume   --> MPD: raise volume
      , ((modm, xK_q)                     , spawn "ghc --make /home/kalex/.xmonad/xmobar.hs && xmonad --recompile && xmonad --restart")
    ]

-- Add myKeyBindings to the default keybindings and save into myKeys
myKeys = \c -> myKeyBindings c `M.union` keys kde4Config c
 
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
myFocusedBorderColor = "darkorange"

myLayout
    = tiling
  ||| Mirror tiling
  where
    -- default tiling algorithm partitions the screen into two panes
    tiling   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 3/5

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

myLayoutHook 
  = avoidStruts 
  $ mySpacing
  $ smartBorders
  $ mkToggle (NOBORDERS ?? FULL ?? EOT) -- switch to fullscreen layout  
   ( myLayout )

--------------------------------------------------------------------------------
-- WORKSPACE
--------------------------------------------------------------------------------

-- Define my workspaces (statically)
-- myWorkspaces = ["1: <fn=1>\xE745 </fn>","2: <fn=1>\xF120 </fn>", "3: <fn=1>\xF668 </fn>", "4: <fn=1>\xFB6E </fn>", "5: <fn=1>\xFB75 </fn>", "6", "7", "8", "9"]


myWorkspaces = clickable $ ["1: <fc=yellow><fn=1>\xF79F </fn></fc>","2: <fc=#33ff00><fn=1>\xF120 </fn></fc>", "3: <fc=#ffff00><fn=1>\xF668 </fn></fc>", "4: <fc=#289ed9><fn=1>\xF2C6 </fn></fc>", "5: <fn=1>\xFB75 </fn>", "6", "7", "8", "9"]
  where                                                                       
         clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip [1..9] l,                                        
                            let n = i ]


-- Define the manageHook to use
myManageHook = composeAll . concat $
    [  
      -- This entry is used to make plasmashell work with xmonad
      [ className =? "plasmashell" <&&> isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_NOTIFICATION" --> doIgnore
          , isDialog --> doFloat
          , isFullscreen --> doFullFloat]

      -- KDE system tray support (NOTICE: this works because there is a single plasma object started with plasmawindowed!)
      , [ className =? "plasmawindowed" --> doIgnore ]

      -- Start SpeedCrunch at the center of the screen, resized to be small enough
      , [ title =? "SpeedCrunch" --> doRectFloat (W.RationalRect 0.25 0.25 0.5 0.5)]
      
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
      , [ fmap ( c `isInfixOf` ) className --> doCenterFloat | c <- myCenterFloatsClass]
      , [ fmap ( t `isInfixOf` ) title --> doCenterFloat | t <- myCenterFloatsTitle ]
    ]
  where viewShift = doF . liftM2 (.) W.greedyView W.shift
        myWs0Class   = ["firefox"]
        myWs1Class   = ["code-oss", "pycharm", "clion", "webstorm", "phpstorm"]
        myWs2Class   = ["okular"]
        myWs3Class   = []
        myWs4Class   = ["Chromium"]
        
        myWs0Title   = []
        myWs1Title   = ["Ghidra"]
        myWs2Title   = ["Lutris","League"]
        myWs3Title   = ["Discord", "Teams", "Telegram", "Signal"]
        myWs4Title   = ["Cantata"]

        myFloatsClass     = []
        myFloatsTitle     = []

        myIgnoreClass     = []
        myIgnoreTitle     = ["win0"] -- jetbrains ide opens this when starting

        myCenterFloatsClass = []
        myCenterFloatsTitle = ["KCalc"]

--------------------------------------------------------------------------------
-- STARTUP
--------------------------------------------------------------------------------

myStartupHook = do
  -- Some appplication, as CLion, refuses to work with xmonad.
  -- Simply make them think this is not xmonad fixes everything!
  setWMName "LG3D"

--------------------------------------------------------------------------------
-- XMOBAR
--------------------------------------------------------------------------------

myLogHook h = dynamicLogWithPP $ 
  xmobarPP 
    {
      ppOutput = hPutStrLn h                                            -- where to write
      , ppCurrent = wrap "<box type=Bottom width=1 color=red>" "</box>" -- color of selected workspace
      , ppLayout = const ""                                             -- layout string to show
      , ppTitle = xmobarColor "#6093ac" "" . shorten 30                 -- Title of the focused window
      , ppSep = "    "                                                  -- separator between things
    }


--------------------------------------------------------------------------------
-- MAIN
--------------------------------------------------------------------------------

main = do

  -- Create a xmobar instance and keep a pipe open
  xmob <- spawnPipe "/home/kalex/.xmonad/xmobar"
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
      , logHook = myLogHook xmob
      , keys = myKeys
      , focusFollowsMouse  = myFocusFollowsMouse
      , clickJustFocuses   = myClickJustFocuses
    }
