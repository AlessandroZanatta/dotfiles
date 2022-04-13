local lain = require "lain"
local wibox = require "wibox"
local markup = lain.util.markup
local beautiful = require "beautiful"

-- ALSA volume
local icon = wibox.widget.imagebox(beautiful.widget_vol)
local widget = lain.widget.alsa {
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup.fontfg(beautiful.font, "#7493d2", volume_now.level .. "% "))
    end,
}

return {
    widget = widget,
    icon = icon,
}
