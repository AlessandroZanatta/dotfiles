Config { 

   -- appearance
     font = "xft:Hack:size=9:bold:antialias=true"
       , additionalFonts         = [ "xft:mononoki Nerd Font:pixelsize=16:antialias=true:hinting=true", "xft:mononoki Nerd Font:pixelsize=20:Regular:antialias=true" ]
   , textOffsets  = [14, 15] -- align xft fonts correctly
   , bgColor      = "#141a21"
   , fgColor      = "#dddddd"
   , position     = Top
   , border       = BottomB
   , borderColor  = "#646464"

   -- layout
   , sepChar  =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"   -- separator between left-right alignment
   -- The template is a big mess because we are using a powerline-like template!
   , template = "<fc=white,#434343:0><action=xdotool key super+p>   <fn=1> </fn>  <fc=#434343,#141a21><fn=2></fn></fc></action></fc>\
     \    %UnsafeStdinReader% } \
     \%date% { \
     \<fc=#A0A0A0><fn=2></fn></fc><fc=#222222,#A0A0A0:0>  %internet%  %bluetooth% </fc>\
     \<fc=#5A5A5A,#A0A0A0><fn=2></fn></fc><fc=#eeeeee,#5A5A5A:0>  %cpu%  </fc><fc=#999999,#5A5A5A>\
     \<fn=2></fn></fc><fc=#eeeeee,#5A5A5A:0>  %memory%  </fc><fc=white,#434343:0></fc>\
     \<fc=#434343,#5A5A5A><fn=2></fn></fc><fc=#eeeeee,#434343:0>  %battery%  </fc>\
     \<action=xdotool key super+shift+q><fc=#222222,#434343><fn=2></fn></fc><fc=darkorange,#222222:0> <fn=1>⏻ </fn> </fc></action>"

   -- general behavior
   , lowerOnStart     = False   -- send to bottom of window stack on start
   , hideOnStart      = False   -- start with window unmapped (hidden)
   , allDesktops      = True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest     = False   -- choose widest display (multi-monitor)
   , persistent       = True    -- enable/disable hiding (True = disabled)

   -- plugins
   --   Numbers can be automatically colored according to their value. xmobar
   --   decides color based on a three-tier/two-cutoff system, controlled by
   --   command options:
   --     --Low sets the low cutoff
   --     --High sets the high cutoff
   --
   --     --low sets the color below --Low cutoff
   --     --normal sets the color between --Low and --High cutoffs
   --     --High sets the color above --High cutoff
   --
   --   The --template option controls how the plugin is displayed. Text
   --   color can be set by enclosing in <fc></fc> tags. For more details
   --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
   , commands = 

        [ 
        -- This line tells xmobar to read input from stdin. That's how we
	-- get the information that xmonad is sending it for display.
	Run UnsafeStdinReader

        --, Run Battery [ "--template" , "<fn=1> </fn><left>%"
                             --, "--Low"      , "20"        -- units: %
                             --, "--High"     , "80"        -- units: %
                             --, "--low"      , "#BF616A"
                             --, "--normal"   , "#EBCB8B"
                             --, "--high"     , "#A3BE8C"
                             --, "--" ---- battery specific options
                                       ---- discharging status - use icons
                                       --, "-l"   ,  "#BF616A"
                                       --, "-m"   ,  "#EBCB8B"
                                       --, "-h"   ,  "#A3BE8C"
                                       --, "-o"   , ""
                                       --, "--lows"     , "<fn=1> </fn><left>% <timeleft>"
                                       --, "--mediums"  , "<fn=1> </fn><left>% <timeleft>"
                                       --, "--highs"    , "<fn=1> </fn><left>% <timeleft>"
                                       ---- AC "on" status
                                       --, "-O"  , "<fn=1> </fn><left>% <timeleft>"
                                       ---- charged status
                                       --, "-i"  , "<fn=1> </fn><left>% <timeleft>"
                                       -- , "-a", "notify-send -u critical 'Battery running out!!'"
                                       -- , "-A", "20"
                             -- ] 50

        -- Cpu monitor
        , Run Cpu          [ "--template"   , "<fn=1> </fn><total>%" 
                             --,"--Low"       , "40"
                             --, "--High"     , "90"
                             --, "--low"      , "darkgreen"
                             --, "--normal"   , "darkorange"
                             --, "--high"     , "red"
                           ] 10

        -- Memory usage monitor
        , Run Memory       [ "--template" , "<fn=1> </fn> <usedratio>%"
                             -- , "--Low"      , "40"        -- units: %
                             -- , "--High"     , "90"        -- units: %
                             -- , "--low"      , "darkgreen"
                             -- , "--normal"   , "darkorange"
                             -- , "--high"     , "red"
                           ] 10
        
        -- Swap usage monitor 
        -- , Run Swap         [ "--template" , "<usedratio>%"
        --                     , "--High"     , "256"
        --                     , "--Low"      , "0"
        --                     , "--low"      , "darkgreen"
        --                     , "--normal"   , "darkorange"
        --                     , "--high"     , "red"
        --                  ] 10

        -- Network activity monitor (dynamic interface resolution)
        -- This configuration is not very dynamic, add "<dev>" to template to make it really dynamic
        -- , Run DynNetwork   [ "--template"   , "<fn=1>\xF0EE </fn> <tx>kB/s  <fn=1>\xF0ED </fn> <rx>kB/s"
        --                     , "--Low"      , "250000"     -- units: B/s
        --                     , "--High"     , "1000000"     -- units: B/s
        --                     , "--low"      , "darkgreen"
        --                     , "--normal"   , "darkorange"
        --                     , "--high"     , "darkred"
        --                   ] 10
        , Run Com "/home/kalex/.xmonad/scripts/internetconnection" [] "internet" 10
        , Run Com "/home/kalex/.xmonad/scripts/bluetoothstatus" [] "bluetooth" 10
        -- , Run Com "/home/kalex/.xmonad/scripts/tray-padding-icon" [] "traypad" 10
        , Run Com "/home/kalex/.xmonad/scripts/battery" [] "battery" 10 
        

        -- Time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run Date           "<fc=#dddddd>%F (%a) %T</fc>" "date" 10

        ]
   }
