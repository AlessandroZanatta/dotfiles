#!/bin/sh

LOGO_ON=""
LOGO_OFF=""

DEFAULT_SOURCE="Capture"
MUTED=$(amixer get "$DEFAULT_SOURCE" | awk '/Front Left:/ {print $6; exit}')
RUNNING=$(cat /proc/asound/card*/pcm*/sub*/status | awk '/RUNNING/' | wc -l | tr -d "\n")

if [ "$RUNNING" -gt 0 ] || [ "$MUTED" != "[on]" ]; then
  if [ "$MUTED" = "[on]" ]; then
    echo "$LOGO_ON"
  else
    echo "%{F#f25287}$LOGO_OFF%{F-}"
  fi
else
  echo ""
fi
