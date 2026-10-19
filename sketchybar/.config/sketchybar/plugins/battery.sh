#!/bin/bash
source "$CONFIG_DIR/colors.sh"
status=$(/usr/bin/pmset -g batt)
percentage=$(printf '%s\n' "$status" | /usr/bin/awk -F '[%;]' '/InternalBattery/ {sub(/^.*[[:space:]]/, "", $1); print $1; exit}')
if [ -z "$percentage" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi
# Material Design battery glyphs included in RobotoMono Nerd Font.
if [ "$percentage" -ge 100 ]; then
  icon='󰁹'
elif [ "$percentage" -ge 90 ]; then
  icon='󰂂'
elif [ "$percentage" -ge 80 ]; then
  icon='󰂁'
elif [ "$percentage" -ge 70 ]; then
  icon='󰂀'
elif [ "$percentage" -ge 60 ]; then
  icon='󰁿'
elif [ "$percentage" -ge 50 ]; then
  icon='󰁾'
elif [ "$percentage" -ge 40 ]; then
  icon='󰁽'
elif [ "$percentage" -ge 30 ]; then
  icon='󰁼'
elif [ "$percentage" -ge 20 ]; then
  icon='󰁻'
else
  icon='󰁺'
fi
case "$status" in
  *"AC Power"*) icon='󰂄' ;;
esac
color="$TEXT"
if [ "$percentage" -le 10 ]; then color="$RED"; fi
sketchybar --set "$NAME" drawing=on icon.drawing=on icon="$icon" \
  icon.color="$color" label.drawing=off
