local awful = require "awful"

local function run_once(cmd)
  local firstspace = cmd:find " "
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

run_once "flameshot"
run_once "locker"
run_once "picom"
run_once "parcellite -n"
run_once "nm-applet"
run_once "autorandr -c"
