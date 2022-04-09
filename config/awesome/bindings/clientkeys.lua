-- Standard Awesome library
local gears = require "gears"
local awful = require "awful"
-- Custom Local Library
-- local titlebar = require("anybox.titlebar")

local _M = {}
local modkey = RC.vars.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
    local clientkeys = gears.table.join(
        awful.key({ modkey }, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, { description = "toggle fullscreen", group = "client" }),
        awful.key({ modkey, "Shift" }, "c", function(c)
            c:kill()
        end, { description = "close", group = "client" }),
        awful.key({ modkey }, "t", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
        awful.key({ modkey }, "o", function(c)
            c:move_to_screen()
        end, { description = "move to screen", group = "client" }),
        awful.key({ modkey }, "m", function(c)
            c.maximized = not c.maximized
            c:raise()
        end, { description = "(un)maximize", group = "client" })
    )

    return clientkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
    __call = function(_, ...)
        return _M.get(...)
    end,
})
