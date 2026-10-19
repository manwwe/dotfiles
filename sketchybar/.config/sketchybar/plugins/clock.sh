#!/bin/bash
source "$CONFIG_DIR/plugins/common.sh"
handle_popup clock "${1:-}" || exit 0
sketchybar --set "$NAME" icon="$(LC_TIME=C /bin/date '+%a %d %b')" \
  label="$(/bin/date '+%H:%M')"
[ "${SENDER:-}" = routine ] && exit 0
row=0
while IFS= read -r line; do
  [ "$row" -ge 8 ] && break
  sketchybar --set "calendar.$row" label="$line" drawing=on
  row=$((row + 1))
done < <(LC_ALL=C /usr/bin/cal)
while [ "$row" -lt 8 ]; do
  sketchybar --set "calendar.$row" drawing=off
  row=$((row + 1))
done
