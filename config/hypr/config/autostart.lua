-------------------
---- AUTOSTART ----
-------------------

local vars = require("config.variables")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	-- General
	hl.exec_cmd("firefox")
	hl.exec_cmd(vars.programs.terminal)

	-- Fundamentals
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("waybar")
	hl.exec_cmd("flameshot") -- screenshots
	hl.exec_cmd("cliphist") -- clipboard manager
	hl.exec_cmd("systemctl --user start hyprpolkitagent") -- polkit
	hl.exec_cmd("swaync")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
	hl.exec_cmd("/usr/lib/xdg-desktop-portal")
	hl.exec_cmd("hyprctl setcursor " .. vars.cursor.cursorTheme .. vars.cursor.cursorSize)

	-- Work stuff
	hl.exec_cmd("thunderbird") -- Emails
	hl.exec_cmd("rocketchat-desktop") -- Work chat
	hl.exec_cmd("nextcloud") -- Cloud sync
end)
