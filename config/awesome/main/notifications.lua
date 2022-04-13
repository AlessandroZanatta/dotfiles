local naughty = require "naughty"
local gears = require "gears"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local nconf = naughty.config
nconf.defaults.border_width = 0
nconf.defaults.margin = 16
nconf.defaults.shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, dpi(6))
end
nconf.defaults.text = "Notification"
nconf.defaults.timeout = 5
nconf.padding = 8
nconf.presets.critical.bg = "#FE634E"
nconf.presets.critical.fg = "#fefefa"
nconf.presets.low.bg = "#1e222a"
nconf.presets.normal.bg = "#1e222a"
nconf.defaults.icon_size = 64
nconf.spacing = 8
-- theme.notification_font = "Inter 12.5"
