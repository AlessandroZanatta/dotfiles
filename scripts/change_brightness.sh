#!/bin/bash

# Arbitrary, but needs to be unique
MSGTAG="my_brightness"

# Set brightness
xbacklight "$@"

# Get current brightness 
BRIGHTNESS=$(xbacklight -get | cut -c 1-2 | awk '{print int($1 / 5 + 0.5) * 5}')

# Show the brightness nofitication
dunstify -a "changeVolume" \
  -u low -i display-brightness \
  -h string:x-dunst-stack-tag:$MSGTAG \
  -h int:value:"$BRIGHTNESS" "Brightness: ${BRIGHTNESS}%"

