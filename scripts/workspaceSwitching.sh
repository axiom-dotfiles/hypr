#!/usr/bin/env bash
#
# Author:      travmonkey
# Date:        2025-09-30
# Description: Switches or moves windows between workspaces on the active monitor.
#              Supports numeric (1-5) and relative (--left/--right) switching.
# Usage:       workspaceSwitching.sh <1-5 | --left | --right> [--move]

# Note: This script is legacy

set -euo pipefail

if [ -z "$1" ]; then
  echo "Usage: $0 <1-5 | --left | --right> [--move]"
  exit 1
fi

operation="workspace"
if [[ "${2:-}" == "--move" ]]; then
  operation="movetoworkspace"
fi

current_monitor=$(hyprctl -j activeworkspace | jq -r .monitor)
current_workspace=$(hyprctl -j activeworkspace | jq .id)

target_workspace=""

# Handle relative movement (--left / --right)
if [[ "$1" == "--left" ]]; then
  if (( current_workspace % 5 == 1 )); then
    # We are on workspace 1, 6, 11, etc.
    echo "No workspace to the left"
    exit 0
  else
    target_workspace=$((current_workspace - 1))
  fi
elif [[ "$1" == "--right" ]]; then
  if (( current_workspace % 5 == 0 )); then
    # We are on workspace 5, 10, 15, etc.
    echo "No workspace to the right"
    exit 0
  else
    target_workspace=$((current_workspace + 1))
  fi
else
  # Handle numeric movement (1-5)
  # Determine the current monitor's workspace block (e.g., 1-5, 6-10, 11-15)
  case $current_workspace in
    [1-5])   inc=0 ;;
    [6-9]|10)  inc=5 ;;
    1[1-5])  inc=10 ;;
    1[6-9]|20) inc=15 ;;
    2[1-5])  inc=20 ;;
    *)       inc=25 ;;
  esac
  target_workspace=$(($1 + inc))
fi

# Dispatch the command for known monitors
if [[ "$current_monitor" == "DP-1" || "$current_monitor" == "DP-2" ]]; then
  hyprctl dispatch "${operation}" "${target_workspace}"
else
  echo "Error: Monitor '$current_monitor' not configured in script."
  exit 1
fi
