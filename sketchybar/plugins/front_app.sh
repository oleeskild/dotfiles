#!/bin/bash
# ~/.config/sketchybar/plugins/front_app.sh

source "$HOME/.config/sketchybar/plugins/icon_map.sh"

__icon_map "$INFO"

sketchybar --set "$NAME" label="$INFO" icon="$icon_result" icon.font="sketchybar-app-font:Regular:16.0"
