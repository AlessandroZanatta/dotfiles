#!/bin/sh

LOGO_ON=""
LOGO_OFF=""

DEFAULT_SOURCE="Capture"
MUTED=$(amixer get "$DEFAULT_SOURCE" | awk '/Front Left:/ {print $6; exit}')

if [ "$MUTED" = "[on]" ]; then
	echo "$LOGO_ON"
else
	echo "%{F#f25287}$LOGO_OFF%{F-}"
fi
