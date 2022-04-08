-- Remove tmux keybinds
package.loaded["awful.hotkeys_popup.keys.tmux"] = {}

-- Handle luarocks
pcall(require, "luarocks.loader")

-- Awesome standard libraries
local gears = require "gears"
local awful = require "awful"

-- Makes sure there always is a focused window
require "awful.autofocus"

-- Theme handling library
local beautiful = require "beautiful"

local lain = require "lain"
--local menubar       = require("menubar")
local hotkeys_popup = require "awful.hotkeys_popup"
require "awful.hotkeys_popup.keys"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RC = {} -- global namespace, on top before require any modules
RC.vars = require "main.variables"

-- Error handling
require "main.error-handling"

-- Autostart applications
require "main.autostart"

-- Custom library
local main = {
    layouts = require "main.layouts",
    tags = require "main.tags",
    rules = require "main.rules",
}

-- Layouts
RC.layouts = main.layouts()

-- Tags
RC.tags = main.tags()

-- Custom Local Library: Keys and Mouse Binding
local bindings = {
    globalbuttons = require "bindings.globalbuttons",
    clientbuttons = require "bindings.clientbuttons",
    globalkeys = require "bindings.globalkeys",
    bindtotags = require "bindings.bindtotags",
    clientkeys = require "bindings.clientkeys",
}

-- Mouse and key bindings
RC.globalkeys = bindings.globalkeys()
RC.globalkeys = bindings.bindtotags(RC.globalkeys)

-- Set root
root.buttons(bindings.globalbuttons())
root.keys(RC.globalkeys)

local themes = {
    "blackburn", -- 1
    "copland", -- 2
    "dremora", -- 3
    "holo", -- 4
    "multicolor", -- 5
    "powerarrow", -- 6
    "powerarrow-dark", -- 7
    "rainbow", -- 8
    "steamburn", -- 9
    "vertex", -- 10,
    "my_theme", -- 11
}

local chosen_theme = themes[5]
local modkey = RC.vars.modkey
local mytable = awful.util.table or gears.table

-- Temporarily defined this way for compatibility
awful.util.terminal = RC.vars.terminal
awful.util.tagnames = RC.tags
awful.layout.layouts = RC.layouts

awful.util.taglist_buttons = mytable.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

awful.util.tasklist_buttons = mytable.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list { theme = { width = 250 } }
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv "HOME", chosen_theme))

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    beautiful.at_screen_connect(s)
end)

-- }}}

-- Signals
require "main.signals"

-- Rules
awful.rules.rules = main.rules(bindings.clientkeys(), bindings.clientbuttons())
