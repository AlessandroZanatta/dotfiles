---------------------
---- KEYBINDINGS ----
---------------------

local vars = require("config.variables")

local mainMod = vars.binds.mainMod

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(vars.programs.terminal))
hl.bind(mainMod .. "+ SHIFT + C", hl.dsp.window.close())

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("hyrpctl reload"))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(vars.programs.menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(
	mainMod .. " + SHIFT + S",
	hl.dsp.exec_cmd(
		'grim -g "$(slurp)" - | satty -f - --copy-command wl-copy -o ~/Pictures/Screenshots/%Y%m%d_%H%M%S.png'
	)
)

hl.bind(mainMod .. " + O", hl.dsp.focus({ last = true }))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with mainMod + arrow keys
for _, direction in ipairs({ "left", "right", "up", "down" }) do
	hl.bind(mainMod .. " + " .. direction, hl.dsp.focus({ direction = direction }))
	hl.bind(mainMod .. " + SHIFT + " .. direction, hl.dsp.window.move({ direction = direction }))
end

hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ monitor = "+1" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = key, on_current_monitor = true }))
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Cycle layout on current workspace
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Uncommon-tips-and-tricks/#cycle-layout-for-current-workspace
hl.bind(mainMod .. " + space", function()
	local layouts = { "scrolling", "dwindle", "master", "monocle" }
	local workspace = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end

	local next_layout = "dwindle"

	if not workspace then
		return
	end

	for i = 1, #layouts do
		if layouts[i] == workspace.tiled_layout then
			local next_layout_idx = (i % #layouts) + 1
			next_layout = layouts[next_layout_idx]
			break
		end
	end

	if workspace.special then
		hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
	else
		hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
	end
end)
