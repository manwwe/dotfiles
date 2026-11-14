#!/bin/bash
source "$CONFIG_DIR/plugins/common.sh"
handle_popup worldclock "${1:-}" || exit 0
# Render only on open/refresh, or while the popup is visible.
if [ "${SENDER:-}" = routine ]; then
  sketchybar --query worldclock | /usr/bin/jq -e '.popup.drawing == "on"' >/dev/null || exit 0
fi
python3 "$CONFIG_DIR/helpers/world_clock.py"
