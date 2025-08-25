
#!/usr/bin/env bash
# Switch between workspaces in a 5x5 grid (independent of monitor)
# Usage: wasd.sh [--left] [--right] [--up] [--down]

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: wasd.sh [--left] [--right] [--up] [--down]"
  exit 1
fi

GRID_W=5
GRID_H=5

# Current workspace + monitor (informational)
current_monitor=$(hyprctl -j activeworkspace | jq -r .monitor)
current_workspace=$(hyprctl -j activeworkspace | jq .id)

# Derive row/col (rows: 1=top .. 5=bottom; cols: 1=left .. 5=right)
row=$(( ( (current_workspace - 1) / GRID_W ) + 1 ))
col=$(( ( (current_workspace - 1) % GRID_W ) + 1 ))

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
  hyprctl dispatch workspace "$target_workspace"
  hyprctl keyword animation "workspaces, 1, 2.5, wind, slide"
else
  hyprctl dispatch workspace "$target_workspace"
fi

exit 0
