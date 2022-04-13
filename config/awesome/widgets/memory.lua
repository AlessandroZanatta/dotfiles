local lain = require "lain"
local wibox = require "wibox"
local markup = lain.util.markup
local beautiful = require "beautiful"

-- MEM
local icon = wibox.widget.imagebox(beautiful.widget_mem)
local widget = lain.widget.mem {
    settings = function()
        widget:set_markup(markup.fontfg(beautiful.font, "#e0da37", mem_now.used .. "M "))
    end,
}

return {
    widget = widget,
    icon = icon,
}
