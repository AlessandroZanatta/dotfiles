-- Standard awesome library
local gears = require "gears"
local awful = require "awful"
local beautiful = require "beautiful"
local naughty = require "naughty"
local lain = require "lain"

-- local hotkeys_popup = require("awful.hotkeys_popup").widget
local hotkeys_popup = require "awful.hotkeys_popup"

-- Resource Configuration
local modkey = RC.vars.modkey
local altkey = RC.vars.modkey
local terminal = RC.vars.terminal

local _M = {}

-- reading
-- https://awesomewm.org/wiki/Global_Keybindings

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
    local globalkeys = gears.table.join(

        -- Destroy all notifications
        awful.key({ "Control" }, "space", function()
            naughty.destroy_all_notifications()
        end, { description = "destroy all notifications", group = "hotkeys" }),

        -- Take a screenshot
        awful.key({ modkey, "Shift" }, "s", function()
            awful.spawn "flameshot gui"
        end, { description = "take a screenshot", group = "hotkeys" }),

        -- X screen locker
        awful.key({ modkey, "Shift" }, "l", function()
            awful.spawn "/usr/local/bin/lock"
        end, { description = "lock screen", group = "hotkeys" }),

        -- Show help
        awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

        -- Tag browsing
        awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
        awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
        awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

        -- Default client focus
        awful.key({ modkey }, "j", function()
            awful.client.focus.byidx(1)
        end, { description = "focus next by index", group = "client" }),
        awful.key({ modkey }, "k", function()
            awful.client.focus.byidx(-1)
        end, { description = "focus previous by index", group = "client" }),

        -- Layout manipulation
        awful.key({ modkey, "Shift" }, "j", function()
            awful.client.swap.byidx(1)
        end, { description = "swap with next client by index", group = "client" }),
        awful.key({ modkey, "Shift" }, "k", function()
            awful.client.swap.byidx(-1)
        end, { description = "swap with previous client by index", group = "client" }),
        awful.key({ modkey, "Control" }, "j", function()
            awful.screen.focus_relative(1)
        end, { description = "focus the next screen", group = "screen" }),
        awful.key({ modkey, "Control" }, "k", function()
            awful.screen.focus_relative(-1)
        end, { description = "focus the previous screen", group = "screen" }),

        -- Jump to urgent client
        awful.key(
            { modkey },
            "u",
            awful.client.urgent.jumpto,
            { description = "jump to urgent client", group = "client" }
        ),

        -- Show/hide wibox
        awful.key({ modkey }, "b", function()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end, { description = "toggle wibox", group = "awesome" }),

        -- Dynamic tagging
        awful.key({ modkey, "Shift" }, "n", function()
            lain.util.add_tag()
        end, { description = "add new tag", group = "tag" }),
        awful.key({ modkey, "Shift" }, "r", function()
            lain.util.rename_tag()
        end, { description = "rename tag", group = "tag" }),
        awful.key({ modkey, "Shift" }, "Left", function()
            lain.util.move_tag(-1)
        end, { description = "move tag to the left", group = "tag" }),
        awful.key({ modkey, "Shift" }, "Right", function()
            lain.util.move_tag(1)
        end, { description = "move tag to the right", group = "tag" }),
        awful.key({ modkey, "Shift" }, "d", function()
            lain.util.delete_tag()
        end, { description = "delete tag", group = "tag" }),

        -- Standard program
        awful.key({ modkey }, "Return", function()
            awful.spawn(terminal)
        end, { description = "open a terminal", group = "launcher" }),
        awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
        awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

        awful.key({ modkey }, "l", function()
            awful.tag.incmwfact(0.05)
        end, { description = "increase master width factor", group = "layout" }),
        awful.key({ modkey }, "h", function()
            awful.tag.incmwfact(-0.05)
        end, { description = "decrease master width factor", group = "layout" }),
        awful.key({ modkey, "Control" }, "h", function()
            awful.tag.incnmaster(1, nil, true)
        end, { description = "increase the number of master clients", group = "layout" }),
        awful.key({ modkey, "Control" }, "l", function()
            awful.tag.incnmaster(-1, nil, true)
        end, { description = "decrease the number of master clients", group = "layout" }),
        -- awful.key({ modkey, "Control" }, "h", function()
        --     awful.tag.incncol(1, nil, true)
        -- end, { description = "increase the number of columns", group = "layout" }),
        -- awful.key({ modkey, "Control" }, "l", function()
        --     awful.tag.incncol(-1, nil, true)
        -- end, { description = "decrease the number of columns", group = "layout" }),
        awful.key({ modkey }, "space", function()
            awful.layout.inc(1)
        end, { description = "select next", group = "layout" }),
        awful.key({ modkey, "Shift" }, "space", function()
            awful.layout.inc(-1)
        end, { description = "select previous", group = "layout" }),

        -- Screen brightness
        awful.key({}, "XF86MonBrightnessUp", function()
            os.execute "xbacklight -inc 10"
        end, { description = "+10%", group = "hotkeys" }),
        awful.key({}, "XF86MonBrightnessDown", function()
            os.execute "xbacklight -dec 10"
        end, { description = "-10%", group = "hotkeys" }),

        -- ALSA volume control
        awful.key({ altkey }, "Up", function()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end, { description = "volume up", group = "hotkeys" }),
        awful.key({ altkey }, "Down", function()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end, { description = "volume down", group = "hotkeys" }),
        awful.key({ altkey }, "m", function()
            os.execute(
                string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel)
            )
            beautiful.volume.update()
        end, { description = "toggle mute", group = "hotkeys" }),
        awful.key({ altkey, "Control" }, "m", function()
            os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
            beautiful.volume.update()
        end, { description = "volume 100%", group = "hotkeys" }),
        awful.key({ altkey, "Control" }, "0", function()
            os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
            beautiful.volume.update()
        end, { description = "volume 0%", group = "hotkeys" }),

        -- Default
        --[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    --]]
        --[[ dmenu
    awful.key({ modkey }, "x", function ()
            os.execute(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"}),
    --]]
        -- alternatively use rofi, a dmenu-like application with more features
        -- check https://github.com/DaveDavenport/rofi for more details
        --[[ rofi
    awful.key({ modkey }, "x", function ()
            os.execute(string.format("rofi -show %s -theme %s",
            'run', 'dmenu'))
        end,
        {description = "show rofi", group = "launcher"}),
    --]]
        -- Prompt
        awful.key({ modkey }, "p", function()
            awful.spawn "/home/kalex/.config/rofi/launchers/text/launcher.sh"
        end, { description = "run prompt", group = "launcher" })
        --]]
    )

    return globalkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
    __call = function(_, ...)
        return _M.get(...)
    end,
})
