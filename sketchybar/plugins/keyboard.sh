#!/bin/bash
# ~/.config/sketchybar/plugins/keyboard.sh

LAYOUT=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null | sed 's/com.apple.keylayout.//')

case "$LAYOUT" in
  Norwegian) LABEL="NO" ;;
  US)        LABEL="US" ;;
  *)         LABEL="$LAYOUT" ;;
esac

sketchybar --set "$NAME" label="$LABEL"
