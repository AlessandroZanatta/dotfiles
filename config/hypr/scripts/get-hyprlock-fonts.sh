#!/bin/bash

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

install_font() {
  local dest="$FONTS_DIR/$1"
  local url="$2"
  if [ ! -f "$dest" ]; then
    echo "Installing: $1"
    mkdir -p "$(dirname "$dest")"
    wget -q -O "$dest" "$url"
  else
    echo "Skipping (exists): $1"
  fi
}

BASE="https://raw.githubusercontent.com/MrVivekRajan/Hyprlock-Styles/e8489df1de8a1f589f90e14cc799bc14262144c5/Style-7/Fonts"

install_font "SF Pro Display/SF Pro Display Bold.otf" "$BASE/SF Pro Display/SF Pro Display Bold.otf"
install_font "SF Pro Display/SF Pro Display Regular.otf" "$BASE/SF Pro Display/SF Pro Display Regular.otf"
install_font "StretchPro/StretchPro.otf" "$BASE/StretchPro/StretchPro.otf"
install_font "Suisse Int'l Mono/Suisse Int'l Mono.ttf" "$BASE/Suisse Int'l Mono/Suisse Int%27l Mono.ttf"

# Only rebuild font cache if something was installed
if fc-list | grep -q "SF Pro Display\|StretchPro\|Suisse Int"; then
  echo "Fonts already cached"
else
  echo "Rebuilding font cache..."
  fc-cache -fv
fi
