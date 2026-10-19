#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$CONFIG_DIR/colors.sh"
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
if [ "$1" = "$focused" ]; then
  sketchybar --set "$NAME" background.drawing=on label.color=0xff1e1e2e
else
  sketchybar --set "$NAME" background.drawing=off label.color="$TEXT"
fi
