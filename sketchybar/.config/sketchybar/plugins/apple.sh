#!/bin/bash
if [ -n "${1:-}" ]; then
  sketchybar --set apple popup.drawing=off
  case "$1" in
    preferences) /usr/bin/open -a 'System Settings' ;;
    activity) /usr/bin/open -a 'Activity Monitor' ;;
    sleep) /usr/bin/osascript -e 'tell application "System Events" to sleep' ;;
    restart)
      /usr/bin/osascript <<'APPLESCRIPT'
display dialog "Restart your Mac?" with title "Restart" buttons {"Cancel", "Restart"} default button "Cancel" cancel button "Cancel" with icon caution
tell application "System Events" to restart
APPLESCRIPT
      ;;
    shutdown)
      /usr/bin/osascript <<'APPLESCRIPT'
display dialog "Shut down your Mac?" with title "Shut Down" buttons {"Cancel", "Shut Down"} default button "Cancel" cancel button "Cancel" with icon caution
tell application "System Events" to shut down
APPLESCRIPT
      ;;
    lock)
      /usr/bin/osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
      ;;
  esac
  exit $?
fi
source "$CONFIG_DIR/plugins/common.sh"
handle_popup apple "${1:-}" || exit 0
