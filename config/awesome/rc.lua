-- Remove tmux keybinds
package.loaded["awful.hotkeys_popup.keys.tmux"] = {}

-- Handle luarocks
pcall(require, "luarocks.loader")

-- Awesome standard libraries
local gears = require "gears"
local awful = require "awful"

-- Makes sure there always is a focused window
require "awful.autofocus"

require "awful.hotkeys_popup.keys"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RC = {} -- global namespace, on top before require any modules
RC.vars = require "main.variables"

-- Error handling
require "main.error-handling"

-- Autostart applications
require "main.autostart"

-- Custom library
local main = {
    layouts = require "main.layouts",
    tags = require "main.tags",
    rules = require "main.rules",
}

-- Layouts
awful.layout.layouts = main.layouts()

-- Tags
main.tags()

-- Notifications
require "main.notifications"

require "main.theme"

-- Custom Local Library: Keys and Mouse Binding
local bindings = {
    globalbuttons = require "bindings.globalbuttons",
    clientbuttons = require "bindings.clientbuttons",
    globalkeys = require "bindings.globalkeys",
    bindtotags = require "bindings.bindtotags",
    clientkeys = require "bindings.clientkeys",
}

-- Statusbar
require "statusbar.statusbar"

-- Mouse and key bindings
RC.globalkeys = bindings.globalkeys()
RC.globalkeys = bindings.bindtotags(RC.globalkeys)

-- Set root
root.buttons(bindings.globalbuttons())
root.keys(RC.globalkeys)

-- Signals
require "main.signals"

-- Rules
awful.rules.rules = main.rules(bindings.clientkeys(), bindings.clientbuttons())
