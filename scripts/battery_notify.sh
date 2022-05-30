#!/bin/bash

# Arbitrary, but need to be unique
MSGTAG="my_battery_notification"

# Power is always a multiple of 10
POWER=$(cat /sys/class/power_supply/BAT0/capacity)
POWER_10=$(echo "$POWER" | awk '{print int($1 / 10 + 0.5) * 10}')
PLUGGED=$(cat /sys/class/power_supply/BAT0/status)

# Select correct icon based on current power and status
if ((POWER_10 == 100)); then
  ICON="battery-level-100-charged-symbolic"
elif [ "$PLUGGED" == "Discharging" ]; then
  ICON="battery-level-$POWER_10-symbolic"
else
  ICON="battery-level-$POWER_10-charging-symbolic"
fi

# Build args based on current power and status
ARGS=(
  -h string:x-dunst-stack-tag:"$MSGTAG"
  -i "$ICON"
  -h "int:value:$POWER"
)

# Set text, notification level and time
if [ "$PLUGGED" == "Discharging" ]; then
  ARGS+=("Power unplugged ($POWER%)")
  if ((POWER <= 20)); then
    ARGS+=(-u critical)
    ARGS+=("Connect to power soon!")
  else
    ARGS+=(-u low)
    ARGS+=(-t 4000)
  fi
else
  ARGS+=(-u low)
  ARGS+=("Power plugged ($POWER%)")
fi

# My battery doesn't seem to output events when changing current capacity
# Therefore, I just have to use a cronjob. The cronjob passes an argument
# that avoids having a notification about battery level every 5 minutes when
# the battery is charging
if [ $# -eq 0 ] || ([ "$PLUGGED" == "Discharging" ] && ((POWER <= 20))); then
  dunstify "${ARGS[@]}"
fi
