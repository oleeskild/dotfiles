#!/bin/bash
# ~/.config/sketchybar/plugins/battery.sh

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep -c "AC Power")

ACCENT2=0xff9ece6a   # green
WARNING=0xffe0af68   # orange
DANGER=0xfff7768e    # red
CHARGING_COLOR=0xff7aa2f7  # blue

if [ "$CHARGING" -gt 0 ]; then
  ICON="󰂄"
  COLOR=$CHARGING_COLOR
elif [ "$PERCENTAGE" -ge 80 ]; then
  ICON="󰁹"
  COLOR=$ACCENT2
elif [ "$PERCENTAGE" -ge 60 ]; then
  ICON="󰂀"
  COLOR=$ACCENT2
elif [ "$PERCENTAGE" -ge 40 ]; then
  ICON="󰁾"
  COLOR=$WARNING
elif [ "$PERCENTAGE" -ge 20 ]; then
  ICON="󰁼"
  COLOR=$WARNING
else
  ICON="󰁺"
  COLOR=$DANGER
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%"
