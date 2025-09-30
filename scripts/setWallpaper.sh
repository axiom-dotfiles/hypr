#!/usr/bin/env bash
# Check if a wallpaper path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_wallpaper_image>"
  echo "Example: $0 ~/Pictures/wallpapers/my_awesome_bg.png"
  exit 1
fi

WALLPAPER_PATH="$1"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Transition config
FPS=144
transitions=("wipe" "any" "outer" "wave")
rand=$[$RANDOM % ${#transitions[@]}]
TYPE=${transitions[$rand]}
DURATION=1
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Check if swaybg is running and kill it if so
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Get current active monitor for monitor-specific wallpaper setting
current_monitor=$(hyprctl -j activeworkspace | jq .monitor | tr -d '"')

# Initialize swww if it's not already running
swww query || swww init

# Set the wallpaper on the current active monitor
swww img -o "$current_monitor" "$WALLPAPER_PATH" $SWWW_PARAMS

# Original script's logic to update a symlink
if [[ "$current_monitor" == "DP-1" ]]; then
  rm -f "$HOME"/.current_wallpaper
  ln -s "$WALLPAPER_PATH" "$HOME"/.current_wallpaper
fi
