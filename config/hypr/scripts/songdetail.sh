#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 --status | --title | --arturl | --blurarturl | --artist | --length | --album | --source"
  exit 1
fi

# Function to get metadata using playerctl
get_metadata() {
  key=$1
  playerctl metadata --format "{{ $key }}" 2>/dev/null
}

# Check for arguments

# Function to determine the source and return an icon and text
get_source_info() {
  trackid=$(get_metadata "mpris:trackid")
  if [[ "$trackid" == *"firefox"* ]]; then
    echo -e "Firefox 󰈹"
  elif [[ "$trackid" == *"spotify"* ]]; then
    echo -e "Spotify "
  elif [[ "$trackid" == *"chromium"* ]]; then
    echo -e "Chrome "
  else
    echo ""
  fi
}

# Generates both art and blurart if song changed, or files are missing
ensure_art_cache() {
  local cache_id="/tmp/hyprlock_art.id"
  local art="/tmp/hyprlock_art.png"
  local blurred="/tmp/hyprlock_art_blur.png"
  local current_id
  local cached_id
  current_id=$(get_metadata "xesam:title")
  cached_id=$(cat "$cache_id" 2>/dev/null)

  if [ "$current_id" != "$cached_id" ] || [ ! -f "$art" ] || [ ! -f "$blurred" ]; then
    local url
    local path
    url=$(get_metadata "mpris:artUrl")
    path="$url"
    [[ "$url" == file://* ]] && path="${url#file://}"
    cp "$path" "$art"
    echo "$current_id" >"$cache_id"
    # Generate blur in background so lock.sh doesn't wait for magick
    magick "$art" -resize 460x130^ -gravity center -extent 460x130 -blur 0x18 "$blurred" &
  fi
}

# Parse the argument
case "$1" in
--title)
  title=$(get_metadata "xesam:title")
  if [ "$title" = "" ]; then
    echo ""
  else
    echo "${title:0:28}" # Limit the output to 50 characters
  fi
  ;;
--arturl)
  ensure_art_cache
  echo "/tmp/hyprlock_art.png"
  ;;
--blurarturl)
  ensure_art_cache
  echo "/tmp/hyprlock_art_blur.png"
  ;;
--artist)
  artist=$(get_metadata "xesam:artist")
  if [ "$artist" = "" ]; then
    echo ""
  else
    echo "${artist:0:30}" # Limit the output to 50 characters
  fi
  ;;
--length)
  length=$(get_metadata "mpris:length")
  if [ "$length" = "" ]; then
    echo ""
  else
    # Convert length from microseconds to a more readable format (seconds)
    echo "$(echo "scale=2; $length / 1000000 / 60" | bc) m"
  fi
  ;;
--status)
  status=$(playerctl status 2>/dev/null)
  if [[ $status == "Playing" ]]; then
    echo ""
  elif [[ $status == "Paused" ]]; then
    echo ""
  else
    echo ""
  fi
  ;;
--album)
  album=$(playerctl metadata --format "{{ xesam:album }}" 2>/dev/null)
  if [[ -n $album ]]; then
    echo "$album"
  else
    status=$(playerctl status 2>/dev/null)
    if [[ -n $status ]]; then
      echo "Not album"
    else
      echo ""
    fi
  fi
  ;;
--source)
  get_source_info
  ;;
*)
  echo "Invalid option: $1"
  echo "Usage: $0 --status | --title | --arturl | --blurarturl | --artist | --length | --album | --source"
  exit 1
  ;;
esac
