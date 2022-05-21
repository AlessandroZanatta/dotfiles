#!/bin/bash

# Arbitrary, but needs to be unique
MSGTAG="my_output_volume"

# Set volume
amixer -q set Master "$@"

# Get current volume
VOLUME=$(amixer get Master | awk '/Front Left:/ {print $5}' | sed 's/[^0-9]*//g')

# Get mute status
MUTE=$(amixer get Master | awk '/Front Left:/ {print $6}' | sed 's/[^a-z]*//g')
if [[ $VOLUME == 0 || $MUTE == "off" ]]; then
  # Show the mute icon
  dunstify -a "change_volume" -t 2000 \
    -u low -i audio-volume-muted \
    -h string:x-dunst-stack-tag:$MSGTAG \
    -h int:value:"0" "Volume muted"
else
  # Show the volume nofitication
  dunstify -a "change_volume" -t 2000 \
    -u low -i audio-volume-high \
    -h string:x-dunst-stack-tag:$MSGTAG \
    -h int:value:"$VOLUME" "Volume: ${VOLUME}%"
fi

# Play the volume changed sound
canberra-gtk-play -i audio-volume-change -d "changeVolume"
