local wibox = require "wibox"

-- Systray
local systray = wibox.widget.systray()
systray:set_base_size(20)

return {
    widget = systray,
}
