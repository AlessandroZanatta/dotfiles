#!/bin/bash

# Arbitrary, but needs to be unique
MSGTAG="my_music_volume"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [+/-]?0.[0-9]+"
  exit 0
fi

CHANGE="$1"

# Get current volume
CURRENT_VOLUME=$(playerctl volume)

# Calculate new volume (rounded)
NEW_VOLUME=$(awk "BEGIN{ print $CURRENT_VOLUME + $CHANGE }")

NEW_VOLUME_PERCENTAGE=$(awk "BEGIN{ print $NEW_VOLUME * 100 }")

# Set volume
playerctl volume "$NEW_VOLUME"

# Show the volume nofitication
dunstify -a "change_input_volume" -t 2000 \
  -u low -i emblem-music-symbolic \
  -h string:x-dunst-stack-tag:$MSGTAG \
  -h int:value:"$NEW_VOLUME_PERCENTAGE" "Volume: $NEW_VOLUME_PERCENTAGE%"

# Play the volume changed sound
canberra-gtk-play -i audio-volume-change -d "changeVolume"
