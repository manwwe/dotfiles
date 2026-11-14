#!/bin/bash
source "$CONFIG_DIR/plugins/common.sh"
if [ "${1:-}" = open-calendar ]; then
  sketchybar --set clock popup.drawing=off
  /usr/bin/open -a Calendar
  exit $?
fi
handle_popup clock "${1:-}" || exit 0
sketchybar --set clock icon="$(LC_TIME=C /bin/date '+%a %d %b')" \
  label="$(/bin/date '+%H:%M')"
if [ "${SENDER:-}" = routine ]; then
  sketchybar --query clock | /usr/bin/jq -e '.popup.drawing == "on"' >/dev/null || exit 0
fi
python3 "$CONFIG_DIR/helpers/calendar_popup.py" "${1:-}"
python3 "$CONFIG_DIR/helpers/agenda.py" "${1:-}"
