#!/bin/sh

LOGO_ON=" "
LOGO_OFF=""

get_default_source() { DEFAULT_SOURCE="Capture"; }

get_status() {
  get_default_source
  MUTED=$(amixer get "$DEFAULT_SOURCE" | awk '/Front Left:/ {print $6; exit}');
}

is_active() {
  RUNNING=$(cat /proc/asound/card*/pcm*/sub*/status | awk '/RUNNING/' | wc -l | tr -d "\n");
}

while true; do
  get_status
  is_active
  if (( RUNNING > 0  )); then 
      if [ "$MUTED" = "[on]" ]; then
        echo $LOGO_ON
      else 
        echo "%{F#f25287}$LOGO_OFF%{F-}"
      fi
  else
      echo ""
  fi
  sleep 0.5
done
