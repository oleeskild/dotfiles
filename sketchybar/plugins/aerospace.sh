#!/bin/bash
# ~/.config/sketchybar/plugins/aerospace.sh
# Highlights the active workspace, dims inactive ones, shows app icons

source "$HOME/.config/sketchybar/plugins/icon_map.sh"

FOCUSED_WORKSPACE="$FOCUSED_WORKSPACE"
THIS_WORKSPACE="$1"

ACCENT=0xff7aa2f7
TEXT=0xffc0caf5
TEXT_DIM=0xff565f89
VERY_DIM=0xff2d3149
ITEM_BG_ACTIVE=0xff24283a

# Build app icon string for this workspace
APPS=$(aerospace list-windows --workspace "$THIS_WORKSPACE" --format '%{app-name}' 2>/dev/null)
ICON_STRIP=""

if [ -n "$APPS" ]; then
  while IFS= read -r app; do
    __icon_map "$app"
    ICON_STRIP+="${icon_result} "
  done <<< "$APPS"
fi

if [ "$THIS_WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    icon.color=$ACCENT \
    label="${ICON_STRIP}" \
    label.font="sketchybar-app-font:Regular:12.0" \
    label.color=$TEXT \
    label.drawing=on \
    label.y_offset=1 \
    background.drawing=on
else
  WINDOW_COUNT=$(echo "$APPS" | grep -c . 2>/dev/null)
  if [ "$WINDOW_COUNT" -gt 0 ]; then
    sketchybar --set "$NAME" \
      icon.color=$TEXT_DIM \
      label="${ICON_STRIP}" \
      label.font="sketchybar-app-font:Regular:12.0" \
      label.color=$TEXT_DIM \
      label.drawing=on \
      label.y_offset=1 \
      background.drawing=off
  else
    sketchybar --set "$NAME" \
      icon.color=$VERY_DIM \
      label.drawing=off \
      background.drawing=off
  fi
fi
