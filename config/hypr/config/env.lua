-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local vars = require("config.variables")

hl.env("HYPRCURSOR_THEME", vars.cursor.cursorTheme)
hl.env("HYPRCURSOR_SIZE", vars.cursor.cursorSize)
hl.env("XCURSOR_THEME", vars.cursor.cursorTheme)
hl.env("XCURSOR_SIZE", vars.cursor.cursorSize)
hl.env("GTK_THEME", "Adwaita:dark")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
