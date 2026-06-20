-------------------
---- AUTOSTART ----
-------------------

local vars = require("config.variables")
local utils = require("config.utils")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	-- General
	hl.exec_cmd("firefox")

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
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("hyprlauncher -d")

	-- Work stuff
	if utils.is_work_laptop() then
		hl.exec_cmd("thunderbird") -- Emails
		hl.exec_cmd("rocketchat-desktop") -- Work chat
		hl.exec_cmd("nextcloud") -- Cloud sync
	else
		hl.exec_cmd(vars.programs.terminal .. " sh -c 'ssh-agent && bw-ssh-add'") -- unlock of ssh keys with password saved on bitwarden
		hl.exec_cmd("/usr/local/bin/tuxedo-touchpad-switch --set") -- set touchpad state to saved one (Tuxedo touchpad requires special care)
	end
end)
