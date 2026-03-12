#!/bin/bash
# ~/.config/sketchybar/plugins/aerospace_mode.sh
# Shows the current AeroSpace mode when not in normal mode

MODE="$MODE"

ACCENT=0xff7aa2f7
DANGER=0xfff7768e
WARNING=0xffe0af68

if [ "$MODE" = "" ] || [ "$MODE" = "main" ]; then
  sketchybar --set "$NAME" drawing=off
else
  case "$MODE" in
    service)  COLOR=$DANGER;  LABEL="SERVICE" ;;
    resize)   COLOR=$WARNING; LABEL="RESIZE" ;;
    *)        COLOR=$ACCENT;  LABEL="$(echo "$MODE" | tr '[:lower:]' '[:upper:]')" ;;
  esac

  sketchybar --set "$NAME" \
    drawing=on \
    label="$LABEL" \
    label.color=$COLOR \
    icon.color=$COLOR
fi
