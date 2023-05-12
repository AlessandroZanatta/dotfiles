#!/bin/bash

# Arbitrary, but needs to be unique
MSGTAG="my_brightness"

# Set brightness
brightnessctl "$@"

BRIGHTNESS=$(brightnessctl -d intel_backlight -m | cut -d',' -f 4)

# Show the brightness nofitication
dunstify -a "changeBrightness" -t 2000 \
	-u low -i display-brightness \
	-h string:x-dunst-stack-tag:"$MSGTAG" \
	-h int:value:"$BRIGHTNESS" "Brightness: ${BRIGHTNESS}"
