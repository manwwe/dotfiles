#!/bin/bash
active=$("$CONFIG_DIR/helpers/mic_status") || exit 1
if [ "$active" = 1 ]; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
