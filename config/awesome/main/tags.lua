-- Standard awesome library
local awful = require "awful"

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
    tags = {}

    awful.screen.connect_for_each_screen(function(s)
        -- Each screen has its own tag table.
        tags[s] = awful.tag({ " ", " ", " ", " ", " " }, s, RC.layouts[1])
    end)
    return tags
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, {
    __call = function(_, ...)
        return _M.get(...)
    end,
})
