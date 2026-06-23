#!/bin/bash

# Generate cache before locking
~/.config/hypr/scripts/get-hyprlock-fonts.sh
~/.config/hypr/scripts/songdetail.sh --arturl >/dev/null
hyprlock
