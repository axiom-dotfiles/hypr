#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: workspaceTransform.sh [--up] [--down]"
  exit 1
fi

if [ "$1" == "--up" ]; then
  direction="up"
elif [ "$1" == "--down" ]; then
  direction="down"
else
  echo "Invalid argument. Use --up or --down."
  exit 1
fi

current_monitor=$(hyprctl -j activeworkspace | jq -r .monitor)
current_workspace=$(hyprctl -j activeworkspace | jq .id)

# middle range = 6–10
# edges = 1–5 and 11–15
if [ "$current_workspace" -ge 6 ] && [ "$current_workspace" -le 10 ]; then
  # middle: allow any direction
  allowed=1
else
  # edges: only allow moving to the middle
  if [ "$current_workspace" -le 5 ]; then
    # only allow up
    [ "$direction" = "up" ] && allowed=1 || allowed=0
  elif [ "$current_workspace" -ge 11 ] && [ "$current_workspace" -le 15 ]; then
    # only allow down
    [ "$direction" = "down" ] && allowed=1 || allowed=0
  else
    allowed=0
  fi
fi

if [ "$allowed" -ne 1 ]; then
  echo "Move not allowed from workspace $current_workspace with direction $direction."
  exit 0
fi

hyprctl keyword animation "workspaces, 1, 2, wind, slidevert"
if [ "$direction" = "up" ]; then
  target=$((current_workspace + 5))
else
  target=$((current_workspace - 5))
fi

echo "Moving from $current_workspace ($current_monitor) to $target"
hyprctl dispatch workspace "$target"
hyprctl keyword animation "workspaces, 1, 2, wind, slide"

