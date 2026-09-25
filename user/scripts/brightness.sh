#!/usr/bin/env bash
#
# Author:      travmonkey
# Date:        2025-09-30
# Description: Controls monitor brightness using ddcutil for multiple displays.
# Usage:       brightness.sh <inc|dec> [--silent] [--double|--triple]

set -euo pipefail

if ! command -v ddcutil &>/dev/null; then
  echo "Error: ddcutil is not installed." >&2
  exit 1
fi

if [[ ! "$1" =~ ^(inc|dec)$ ]]; then
  printf "Usage: %s <inc|dec> [--silent] [--double|--triple]\n" "$0" >&2
  exit 1
fi

ACTION=$1
SILENT=false
INCREMENT=25

# Parse optional arguments
for arg in "$@"; do
  case "$arg" in
    --silent) SILENT=true ;;
    --double) INCREMENT=50 ;;
    --triple) INCREMENT=75 ;;
  esac
done

# Get current brightness from the first available display
current_brightness=$(ddcutil getvcp 10 2>/dev/null | awk -F'current value = ' '/current value/{print $2}' | cut -d, -f1)
if [ -z "$current_brightness" ]; then
  echo "Error: Could not retrieve current brightness." >&2
  exit 1
fi

target_brightness=$current_brightness

if [[ "$ACTION" == "inc" ]]; then
  target_brightness=$((current_brightness + INCREMENT))
  if ((target_brightness > 100)); then target_brightness=100; fi
else # dec
  target_brightness=$((current_brightness - INCREMENT))
  if ((target_brightness < 0)); then target_brightness=0; fi
fi

# Apply new brightness to both monitors if they exist
ddcutil -d 1 setvcp 0x10 "$target_brightness" &>/dev/null
ddcutil -d 2 setvcp 0x10 "$target_brightness" &>/dev/null

# Send notification unless --silent is passed
if [[ "$SILENT" == false ]]; then
  notify-send -a "Brightness" -u low -i display-brightness-symbolic \
    -h int:value:"$target_brightness" "Brightness: $target_brightness%"
fi
