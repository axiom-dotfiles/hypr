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
  "HDMI-A-1") GRID_START=1 ;;
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

# Parse optional arguments
move=false
silent=false
if [[ "${2:-}" == "--move" ]]; then
  move=true
  if [[ "${3:-}" == "--silent" ]]; then
    silent=true
  fi
fi

current_monitor=$(hyprctl -j activeworkspace | jq -r .monitor)
current_workspace=$(hyprctl -j activeworkspace | jq .id)

# Define the grid start ID for each monitor
case "$current_monitor" in
  "HDMI-A-1") GRID_START=1 ;;
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

# Set animation style based on direction
if [[ "$direction" == "--up" || "$direction" == "--down" ]]; then
  animation_style="slidevert"
else
  animation_style="slide"
fi

# Build the Lua dispatcher expression for the actual move/focus.
# Confirmed patterns (from Hyprland's official example + wiki):
#   focus({ workspace = N })       -- switch active workspace (old: "workspace")
#   window.move({ workspace = N }) -- move active window + follow (old: "movetoworkspace")
# The `silent` flag below (move window WITHOUT switching focus, old:
# "movetoworkspacesilent") is NOT confirmed against the wiki -- I couldn't
# find a documented example of it. If it doesn't work, check the
# Dispatchers page for the real option name and swap it in.
if $move; then
  if $silent; then
    lua_dispatch="hl.dsp.window.move({ workspace = ${target_workspace}, silent = true })"
  else
    lua_dispatch="hl.dsp.window.move({ workspace = ${target_workspace} })"
  fi
else
  lua_dispatch="hl.dsp.focus({ workspace = ${target_workspace} })"
fi

# `keyword` doesn't have a confirmed direct Lua equivalent as of 0.55 (see
# https://github.com/hyprwm/Hyprland/discussions/14525), so the runtime
# animation-style swap now goes through `hyprctl eval` calling hl.animation()
# directly -- it's a config function, not a dispatcher, so it doesn't need
# the hl.dispatch(...) wrapper that `hyprctl dispatch` uses under the hood.
#
# This trades the old single --batch call for three separate hyprctl calls
# (set animation -> move -> reset animation). Not atomic, but the whole
# sequence still runs in well under a frame, so it shouldn't be visible.
hyprctl eval "hl.animation({ leaf = \"workspaces\", enabled = true, speed = 2.5, bezier = \"wind\", style = \"${animation_style}\" })"
hyprctl dispatch "${lua_dispatch}"
hyprctl eval 'hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "wind", style = "fade" })'
