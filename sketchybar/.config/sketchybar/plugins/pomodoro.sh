#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
if [ "${1:-}" = shortcut ]; then
  sketchybar --set pomodoro popup.drawing=off
  /usr/bin/shortcuts run 'Start Pomodoro'
  exit $?
fi
source "$CONFIG_DIR/plugins/common.sh"
handle_popup pomodoro "${1:-}" || exit 0
python3 "$CONFIG_DIR/helpers/pomodoro.py" "${1:-}"
