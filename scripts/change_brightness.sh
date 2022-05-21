#!/bin/bash

# Arbitrary, but needs to be unique
MSGTAG="my_brightness"

# Set brightness
xbacklight "$@"

# Get current brightness, round up to a multiple of five because 
# my brightness range is (for some reason) 0-1666 
BRIGHTNESS=$(xbacklight -get | cut -d . -f1 | awk '{print int($1 / 5 + 0.5) * 5}')

# Show the brightness nofitication
dunstify -a "changeVolume" -t 2000 \
  -u low -i display-brightness \
  -h string:x-dunst-stack-tag:$MSGTAG \
  -h int:value:"$BRIGHTNESS" "Brightness: ${BRIGHTNESS}%"

