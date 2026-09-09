#!/usr/bin/env bash
#
# Description: Toggle the focused monitor between normal and 90° rotation.
#              Runtime-only -- calls hl.monitor() directly via `hyprctl eval`,
#              same approach as wasd.sh's `hyprctl eval "hl.animation(...)"`
#              calls, since `hyprctl keyword` targets the legacy hyprlang
#              parser and doesn't apply against a lua config. Nothing is
#              written to hyprland.lua, so this does not persist across
#              reload/restart.
# Usage:       rotate90.sh [monitor_name]
#              If monitor_name is omitted, the currently focused monitor is used.

set -euo pipefail

target_monitor="${1:-$(hyprctl -j activeworkspace | jq -r .monitor)}"

mon_json=$(hyprctl -j monitors | jq -r --arg m "$target_monitor" '.[] | select(.name==$m)')

if [[ -z "$mon_json" ]]; then
  echo "Error: monitor '$target_monitor' not found." >&2
  exit 1
fi

current_transform=$(jq -r '.transform' <<<"$mon_json")
pos_x=$(jq -r '.x' <<<"$mon_json")
pos_y=$(jq -r '.y' <<<"$mon_json")
scale=$(jq -r '.scale' <<<"$mon_json")

# Two-state toggle: 0 (normal) <-> 1 (90°). Re-running the bind flips it back.
if [[ "$current_transform" == "1" ]]; then
  new_transform=0
else
  new_transform=1
fi

# hl.monitor() is a config function (like hl.animation() in wasd.sh), so it's
# called through `hyprctl eval` rather than wrapped in hl.dispatch(...) --
# that wrapper is only for dispatchers (hl.dsp.*).
#
# NOTE: I couldn't confirm from docs whether calling hl.monitor() at runtime
# via eval actually re-applies the rule live (the wiki only shows it used at
# config-load time), or whether it just registers/overwrites a rule that
# takes effect on the next reload. If rotation doesn't apply immediately,
# that's the likely culprit -- worth checking the Dispatchers page for a
# dedicated runtime transform dispatcher before assuming this is broken.
hyprctl eval "hl.monitor({ output = \"${target_monitor}\", mode = \"preferred\", position = \"${pos_x}x${pos_y}\", scale = ${scale}, transform = ${new_transform} })"
