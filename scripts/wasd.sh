#!/usr/bin/env bash
#
# Author:      travmonkey
# Date:        2025-09-30
# Description: Navigate workspaces in a 5x5 grid using directional commands.
# Usage:       wasd.sh <direction> [--move] [--silent]
#              direction: --left | --right | --up | --down

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 < --left | --right | --up | --down > [--move] [--silent]"
  exit 1
fi

direction=$1
operation="workspace"
# Parse optional arguments
if [[ "${2:-}" == "--move" ]]; then
  operation="movetoworkspace"
  if [[ "${3:-}" == "--silent" ]]; then
    operation="movetoworkspacesilent"
  fi
fi

current_monitor=$(hyprctl -j activeworkspace | jq -r .monitor)
current_workspace=$(hyprctl -j activeworkspace | jq .id)

# Define the grid start ID for each monitor
case "$current_monitor" in
  "DP-1") GRID_START=1 ;;
  "DP-2") GRID_START=26 ;;
  *)
    echo "Error: Monitor '$current_monitor' not configured in script."
    exit 1
    ;;
esac

GRID_W=5
GRID_H=5

row=$(((current_workspace - GRID_START) / GRID_W))
col=$(((current_workspace - GRID_START) % GRID_W))

target_workspace=""

case "$direction" in
  --left)
    if (( col == 0 )); then exit 0; fi
    target_workspace=$((current_workspace - 1))
    ;;
  --right)
    if (( col == GRID_W - 1 )); then exit 0; fi
    target_workspace=$((current_workspace + 1))
    ;;
  --up)
    if (( row == 0 )); then exit 0; fi
    target_workspace=$((current_workspace - GRID_W))
    ;;
  --down)
    if (( row == GRID_H - 1 )); then exit 0; fi
    target_workspace=$((current_workspace + GRID_W))
    ;;
  *)
    echo "Invalid argument: $direction" >&2
    exit 1
    ;;
esac

# Set animation style based on direction and execute
if [[ "$direction" == "--up" || "$direction" == "--down" ]]; then
  animation_style="slidevert"
else
  animation_style="slide"
fi

hyprctl --batch "keyword animation workspaces, 1, 2.5, wind, ${animation_style}; dispatch ${operation} ${target_workspace}; keyword animation workspaces, 1, 2.5, wind, fade"
