------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local utils = require("config.utils")

local function updateMonitors()
	local has_external = utils.has_external_monitor()
	if utils.is_work_laptop() then
		if has_external then
			hl.monitor({
				output = "HDMI-A-1",
				mode = "2560x1440@144",
				position = "auto-center-left",
				scale = 1,
			})
		end

		hl.monitor({
			output = "eDP-1",
			mode = "1920x1080@60",
			position = "0x0",
			scale = 1.33,
		})
	else
		hl.monitor({
			output = "HDMI-A-1",
			mode = "2560x1440@144",
			position = "auto-center-right",
			scale = 1,
		})

		hl.monitor({
			output = "eDP-1",
			mode = "2560x1600@240",
			position = "0x0",
			scale = has_external and 1.6 or 1.33,
		})
	end
end

-- Run once on startup to set initial state
updateMonitors()

-- Listen to the native compositor hardware events to auto-switch layouts instantly
hl.on("monitor.added", updateMonitors)
hl.on("monitor.removed", updateMonitors)
