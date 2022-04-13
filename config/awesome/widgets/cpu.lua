local lain = require "lain"
local wibox = require "wibox"
local markup = lain.util.markup
local beautiful = require "beautiful"

-- CPU
local icon = wibox.widget.imagebox(beautiful.widget_cpu)
local widget = lain.widget.cpu {
    settings = function()
        widget:set_markup(markup.fontfg(beautiful.font, "#e33a6e", cpu_now.usage .. "% "))
    end,
}

return {
    widget = widget,
    icon = icon,
}
