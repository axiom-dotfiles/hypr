#!/usr/bin/env bash
# Switch between workspaces in a 5x5 grid (independent of monitor)
# Usage: wasd.sh [--left] [--right] [--up] [--down]

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: wasd.sh [--|left|right|up|down] [--move] [--silent]"
  exit 1
fi
operation="workspace"
if [ $# -ge 2 ] && [ "$2" == "--move" ]; then
  operation="movetoworkspace"
  echo "Moving window to workspace"
  if [ $# -ge 3 ] && [ "$3" == "--silent" ]; then
    operation="movetoworkspacesilent"
    echo "Moving window to workspace silently"
  fi
fi

current_monitor=$(hyprctl -j activeworkspace | jq -r .monitor)
current_workspace=$(hyprctl -j activeworkspace | jq .id)

if [ "$current_monitor" = "DP-1" ]; then
  GRID_START=1
elif [ "$current_monitor" = "DP-2" ]; then
  GRID_START=26
fi

GRID_W=5
GRID_H=5

row=$(( ( (current_workspace - GRID_START) / GRID_W ) + 1 ))
col=$(( ( (current_workspace - GRID_START) % GRID_W ) + 1 ))

target_workspace=""

case "$1" in
  --left)
    if [ "$col" -eq 1 ]; then
      echo "No workspace to the left"
      exit 0
    fi
    target_workspace=$(( current_workspace - 1 ))
    ;;
  --right)
    if [ "$col" -eq "$GRID_W" ]; then
      echo "No workspace to the right"
      exit 0
    fi
    target_workspace=$(( current_workspace + 1 ))
    ;;
  --up)
    if [ "$row" -eq 1 ]; then
      echo "No workspace above"
      exit 0
    fi
    target_workspace=$(( current_workspace - GRID_W ))
    ;;
  --down)
    if [ "$row" -eq "$GRID_H" ]; then
      echo "No workspace below"
      exit 0
    fi
    target_workspace=$(( current_workspace + GRID_W ))
    ;;
  *)
    echo "Invalid argument. Use --left, --right, --up or --down."
    exit 1
    ;;
esac

echo "Moving from $current_workspace ($current_monitor) to $target_workspace"

# Keep horizontal vs vertical animation behavior the same
if [ "$1" = "--up" ] || [ "$1" = "--down" ]; then
  hyprctl keyword animation "workspaces, 1, 2.5, wind, slidevert"
  hyprctl dispatch ${operation} "$target_workspace"
  hyprctl keyword animation "workspaces, 1, 2.5, wind, fade"
else
  hyprctl keyword animation "workspaces, 1, 2.5, wind, slide"
  hyprctl dispatch "${operation}" "$target_workspace"
  hyprctl keyword animation "workspaces, 1, 2.5, wind, fade"
fi

exit 0
