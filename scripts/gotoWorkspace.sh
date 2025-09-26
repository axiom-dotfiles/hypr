#!/usr/bin/env bash
# Navigate to a specific workspace in a 5x5 grid with animated transitions
# Usage: gotoWorkspace.sh <workspace_id> [--move] [--silent] [--horizontal-first]
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: gotoWorkspace.sh <workspace_id> [--move] [--silent] [--horizontal-first]"
  echo "  workspace_id: Target workspace number (1-25 for DP-1, 26-50 for DP-2)"
  echo "  --move: Move window to workspace instead of switching"
  echo "  --silent: Move window silently (requires --move)"
  echo "  --horizontal-first: Move horizontally first, then vertically (default is vertical-first)"
  exit 1
fi

target_workspace=$1
operation="workspace"
movement_order="vertical-first"

# Parse optional arguments
shift
while [ $# -gt 0 ]; do
  case "$1" in
    --move)
      operation="movetoworkspace"
      echo "Moving window to workspace $target_workspace"
      ;;
    --silent)
      if [ "$operation" = "movetoworkspace" ]; then
        operation="movetoworkspacesilent"
        echo "Moving window to workspace $target_workspace silently"
      fi
      ;;
    --horizontal-first)
      movement_order="horizontal-first"
      echo "Using horizontal-first movement"
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# Get current workspace and monitor
current_monitor=$(hyprctl -j activeworkspace | jq -r .monitor)
current_workspace=$(hyprctl -j activeworkspace | jq .id)

# Determine grid start based on monitor
if [ "$current_monitor" = "DP-1" ]; then
  GRID_START=1
elif [ "$current_monitor" = "DP-2" ]; then
  GRID_START=26
else
  echo "Unknown monitor: $current_monitor"
  exit 1
fi

GRID_W=5
GRID_H=5

# Validate target workspace is in valid range
if [ "$target_workspace" -lt "$GRID_START" ] || [ "$target_workspace" -ge $((GRID_START + GRID_W * GRID_H)) ]; then
  echo "Target workspace $target_workspace is out of range for monitor $current_monitor"
  echo "Valid range: $GRID_START-$((GRID_START + GRID_W * GRID_H - 1))"
  exit 1
fi

# Calculate current position in grid
current_row=$(( ( (current_workspace - GRID_START) / GRID_W ) + 1 ))
current_col=$(( ( (current_workspace - GRID_START) % GRID_W ) + 1 ))

# Calculate target position in grid
target_row=$(( ( (target_workspace - GRID_START) / GRID_W ) + 1 ))
target_col=$(( ( (target_workspace - GRID_START) % GRID_W ) + 1 ))

echo "Current: workspace $current_workspace (row $current_row, col $current_col)"
echo "Target: workspace $target_workspace (row $target_row, col $target_col)"

# If we're already at the target, just ensure we're there
if [ "$current_workspace" -eq "$target_workspace" ]; then
  echo "Already at target workspace"
  exit 0
fi

# Calculate intermediate workspace (same row as current, same column as target)
# or (same column as current, same row as target) depending on movement order
if [ "$movement_order" = "horizontal-first" ]; then
  # Move horizontally first: go to (current_row, target_col)
  intermediate_workspace=$((GRID_START + (current_row - 1) * GRID_W + (target_col - 1)))
  
  # First move: horizontal to target column
  if [ "$current_col" -ne "$target_col" ]; then
    if [ "$target_col" -gt "$current_col" ]; then
      echo "Moving right to column $target_col"
      hyprctl keyword animation "workspaces, 1, 2.5, wind, slide"
    else
      echo "Moving left to column $target_col"
      hyprctl keyword animation "workspaces, 1, 2.5, wind, slide"
    fi
    hyprctl dispatch ${operation} "$intermediate_workspace"
    hyprctl keyword animation "workspaces, 1, 2.5, wind, fade"
  fi
  
  # Second move: vertical to target row
  if [ "$current_row" -ne "$target_row" ]; then
    hyprctl keyword animation "workspaces, 1, 2.5, wind, slidevert"
    hyprctl dispatch ${operation} "$target_workspace"
    hyprctl keyword animation "workspaces, 1, 2.5, wind, fade"
  fi
else
  # Default: Move vertically first: go to (target_row, current_col)
  intermediate_workspace=$((GRID_START + (target_row - 1) * GRID_W + (current_col - 1)))
  
  # First move: vertical to target row
  if [ "$current_row" -ne "$target_row" ]; then
    hyprctl keyword animation "workspaces, 1, 2.5, wind, slidevert"
    hyprctl dispatch ${operation} "$intermediate_workspace"
    hyprctl keyword animation "workspaces, 1, 2.5, wind, fade"
  fi
  
  # Second move: horizontal to target column
  if [ "$current_col" -ne "$target_col" ]; then
    hyprctl keyword animation "workspaces, 1, 2.5, wind, slide"
    sleep 0.08
    hyprctl dispatch ${operation} "$target_workspace"
    hyprctl keyword animation "workspaces, 1, 2.5, wind, fade"
  fi
fi

echo "Arrived at workspace $target_workspace"
exit 0
