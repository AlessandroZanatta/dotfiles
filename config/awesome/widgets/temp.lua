local lain = require "lain"
local wibox = require "wibox"
local markup = lain.util.markup
local beautiful = require "beautiful"

-- Core temperature
local icon = wibox.widget.imagebox(beautiful.widget_temp)
local widget = lain.widget.temp {
    settings = function()
        widget:set_markup(markup.fontfg(beautiful.font, "#f1af5f", coretemp_now .. "°C "))
    end,
}

return {
    widget = widget,
    icon = icon,
}
