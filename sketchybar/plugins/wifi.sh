#!/usr/bin/env bash
# ~/.config/sketchybar/plugins/wifi.sh

HIGHLIGHT=0xff7aa2f7
RED=0xfff7768e

ICON_ON=''
ICON_OFF='󰖪'

CONNECTED=$(scutil --nwi | grep -c "en0")

if [ "$CONNECTED" -gt 0 ]; then
  sketchybar --set "$NAME" \
    icon="$ICON_ON" \
    icon.font="Hack Nerd Font:Regular:16.0" \
    icon.color=$HIGHLIGHT \
    label.drawing=off
else
  sketchybar --set "$NAME" \
    icon="$ICON_OFF" \
    icon.font="Hack Nerd Font:Regular:16.0" \
    icon.color=$RED \
    label.drawing=off
fi
