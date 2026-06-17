-----------------
---- WINDOWS ----
-----------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Per-application window settings
---@param opts? HLWindowRuleOpts
local function shift(match, workspace, opts)
	local rule = opts or {}

	rule.match = match
	rule.workspace = workspace

	hl.window_rule(rule)
end

---@param opts? HLWindowRuleOpts
local function float(match, opts)
	local rule = opts or {}

	rule.match = match
	rule.float = true

	hl.window_rule(rule)
end

---@param opts? HLWindowRuleOpts
local function center_float(match, opts)
	local rule = opts or {}

	rule.center = true

	float(match, rule)
end

---@param opts? HLWindowRuleOpts
local function center_float_no_children(match, opts)
	center_float(match, opts)

	-- Prevent context menus (e.g. speedcrunch ones) from being centered too
	-- TL;DR; already floating (inherited from parent) stuff should not be centered
	local floatingMatch = match
	floatingMatch.float = true
	hl.window_rule({ match = floatingMatch, center = false })
end

-- Workspace rules
shift({ class = "firefox" }, 1)
shift({ class = "org.telegram.desktop" }, 4)
shift({ class = "Rocket.Chat" }, 5, { no_initial_focus = true })
shift({ class = "org.mozilla.Thunderbird" }, 9, { no_initial_focus = true })

-- Float

-- Centered floats
center_float_no_children({ class = "SpeedCrunch" })
center_float({ class = "nemo" })
center_float({ class = "blueman-manager" })
center_float({ class = "com.gabm.satty" })

--- This type is currently missing, add it here to get autocompletion for now
---@meta
---@class HLWindowRuleOpts : HL.WindowRuleSpec
---@field float? boolean Floats a window.
---@field tile? boolean Tiles a window.
---@field fullscreen? boolean Fullscreens a window.
---@field maximize? boolean Maximizes a window.
---@field fullscreen_state? string Sets fullscreen mode, e.g., "1 2".
---@field move? string|table Moves floating window, e.g., "100 200" or {"window_w*0.5", "100"}.
---@field size? string|table Resizes floating window, e.g., {"800", "600"}.
---@field center? boolean Centers window if floating.
---@field pseudo? boolean Pseudotiles a window.
---@field monitor? string Sets monitor to open on, e.g., "1" or "DP-1".
---@field workspace? string|integer Sets workspace to open on.
---@field pin? boolean Pins the window (visible on all workspaces).
---@field stay_focused? boolean Forces focus while visible.
---@field opacity? string Additional opacity multiplier, e.g., "0.8" or "0.9 0.7 override".
---@field border_size? integer Sets the border size.
---@field rounding? integer Forces X pixels of rounding.
---@field no_focus? boolean Disables focus to the window.
---@field no_initial_focus? boolean Disables the initial focus on open.
---@field no_anim? boolean Disables animations for the window.
---@field no_blur? boolean Disables blur for the window.
---@field no_shadow? boolean Disables shadows for the window.
---@field dim_around? boolean Dims everything around this floating window.
