-- Standard awesome library
local gears = require "gears"
local awful = require "awful"

-- Wibox handling library
local wibox = require "wibox"

-- Custom theme
require "main.theme"

local statusbar = {
    wallpaper = require "statusbar.wallpaper",
    taglist = require "statusbar.taglist",
    tasklist = require "statusbar.tasklist",
    widgets = require "widgets.widgets",
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local taglist_buttons = statusbar.taglist()
local tasklist_buttons = statusbar.tasklist()

-- Wibar

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        -- -- Show only tags that are either selected or
        -- -- contain clients (i.e. windows)
        -- filter = function(t)
        --     return t.selected or #t:clients() > 0
        -- end,
        buttons = taglist_buttons,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    }

    -- Create the wibox
    s.mywibox = awful.wibar { position = "top", screen = s }

    -- Systray
    local systray = wibox.widget.systray()
    systray:set_base_size(20)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,

        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        -- Middle widget
        s.mytasklist,

        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            systray,
            -- statusbar.widgets.netdownicon,
            -- statusbar.widgets.netdowninfo,
            -- statusbar.widgets.netupicon,
            -- statusbar.widgets.netupinfo.widget,
            statusbar.widgets.alsa.icon,
            statusbar.widgets.alsa.widget,
            statusbar.widgets.memory.icon,
            statusbar.widgets.memory.widget,
            statusbar.widgets.cpu.icon,
            statusbar.widgets.cpu.widget,
            statusbar.widgets.temp.icon,
            statusbar.widgets.temp.widget,
            statusbar.widgets.battery.icon,
            statusbar.widgets.battery.widget,
            statusbar.widgets.textclock.icon,
            statusbar.widgets.textclock.widget,
        },
    }
end)
