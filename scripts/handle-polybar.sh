#!/bin/bash

if [ "$(pgrep -cx polybar)" -gt 0 ]; then
  echo "The panel is running. Stopping it"
  pkill -nx "polybar"
  sleep 1.5
  while [ "$(pgrep -cx polybar)" -gt 0 ]; do
    pkill -nx -9 "polybar"
  done
fi

for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
  MONITOR=$m polybar --config="$HOME/.config/polybar/config.ini" >> /tmp/polybar.log 2>&1 &
done

wait
