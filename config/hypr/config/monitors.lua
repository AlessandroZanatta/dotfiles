------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "HDMI-A-1",
	mode = "2560x1440@144",
	position = "0x0",
	scale = "1",
})

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "auto-center-right",
	scale = "1.33",
})
