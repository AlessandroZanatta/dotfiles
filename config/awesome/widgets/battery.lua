local lain = require "lain"
local wibox = require "wibox"
local markup = lain.util.markup
local beautiful = require "beautiful"

-- Battery
local icon = wibox.widget.imagebox(beautiful.widget_batt)
local widget = lain.widget.bat {
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        if bat_now.ac_status == 1 then
            perc = perc .. " plug"
        end

        widget:set_markup(markup.fontfg(beautiful.font, beautiful.fg_normal, perc .. " "))
    end,
}

return {
    widget = widget,
    icon = icon,
}
