#!/usr/bin/env bash

# 1. Get the currently focused workspace ID
active_ws=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# 2. Get the current cursor position
read -r cx cy <<<"$(hyprctl cursorpos | tr -d ',')"

# 3. Get the raw window JSON object
window_json=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $active_ws and $cx >= .at[0] and $cx <= (.at[0] + .size[0]) and $cy >= .at[1] and $cy <= (.at[1] + .size[1]))")

# 4. Parse the JSON into a clean, human-readable text block
if [ "$window_json" != "" ]; then
  window_info=$(echo "$window_json" | jq -r '
    to_entries | 
    .[] | 
    "\(.key | ascii_upcase):\t\(.value)"
  ')

  # Send to notification daemon
  notify-send "Window Details" "$window_info" -i system-run
else
  notify-send "Window Details" "No window found under cursor." -i dialog-error
fi
