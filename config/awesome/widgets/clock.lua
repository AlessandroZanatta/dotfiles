local lain = require "lain"
local wibox = require "wibox"
local markup = lain.util.markup
local beautiful = require "beautiful"

-- Textclock
os.setlocale(os.getenv "LANG") -- to localize the clock
local icon = wibox.widget.imagebox(beautiful.widget_clock)
local widget = wibox.widget.textclock(
    markup("#7788af", "%A %d %B ") .. markup("#ab7367", ">") .. markup("#de5e1e", " %H:%M ")
)
widget.font = beautiful.font

return {
    widget = widget,
    icon = icon,
}
