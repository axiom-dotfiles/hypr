#!/usr/bin/env bash

# script to switch between workspaces independant of monitor
# input: workspace number

# read argument to a variable
# check to make sure there is an argument
if [ -z "$1" ]; then
  echo "Usage: workspaceSwitching.sh <workspace number> [--move]"
  exit 1
fi

# get current active monitor
current_monitor=$(hyprctl -j activeworkspace | jq .monitor | tr -d '"')
current_workspace=$(hyprctl -j activeworkspace | jq .id)
target_workspace=$1
keyword="workspace"

echo current_monitor: "$current_monitor"

if [ "$2" == "--move" ]; then
  keyword="movetoworkspace"
fi


# Finding target workspace
# find the realId of the target workspace section
# (e.g. the offset from the closest multiple of 5)
# e.g. 1, 2, 3, 4, 5 -> 1, 2, 3, 4, 5
# e.g. 6, 7, 8, 9, 10 -> 1, 2, 3, 4, 5
# scuffed yea I know

case $current_workspace in
  [0-5])   inc=0 ;;
  [6-9])   inc=5 ;;
  1[0-5])  inc=10 ;;
  1[6-9])  inc=15 ;;
  2[0-5])  inc=20 ;;
  *)       inc=25 ;;
esac

target_workspace=$((target_workspace + inc))


if [ "$1" == "--left" ]; then
  if [ "$current_workspace" -eq 1 ] || [ "$current_workspace" -eq 6 ] || [ "$current_workspace" -eq 11 ]; then
    echo "No workspace to the left"
    exit 0
  else
    target_workspace=$((current_workspace - 1))
  fi
elif [ "$1" == "--right" ]; then
  if [ "$current_workspace" -eq 5 ] || [ "$current_workspace" -eq 10 ] || [ "$current_workspace" -eq 15 ]; then
    echo "No workspace to the right"
    exit 0
  else
    target_workspace=$((current_workspace + 1))
  fi
fi

# switch to workspace
if [ "$current_monitor" == "DP-1" ]; then
  hyprctl dispatch ${keyword} "${target_workspace}"
elif [ "$current_monitor" == "DP-2" ]; then
  hyprctl dispatch ${keyword} "${target_workspace}"
# elif [ "$current_monitor" == "HDMI-A-1" ]; then
#   ((workspace += 10))
#   hyprctl dispatch ${keyword} "${target_workspace}"
# elif [ "$current_monitor" == "DP-3" ]; then
#   ((workspace += 20))
#   hyprctl dispatch ${keyword} "${target_workspace}"
else
  echo "Monitor not found"
  exit 1
fi
