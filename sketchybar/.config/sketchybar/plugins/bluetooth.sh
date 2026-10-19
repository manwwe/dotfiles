#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$CONFIG_DIR/colors.sh"
case "${1:-}" in
  settings)
    sketchybar --set bluetooth popup.drawing=off
    /usr/bin/open 'x-apple.systempreferences:com.apple.BluetoothSettings'
    exit $?
    ;;
  toggle)
    if ! blueutil --power toggle; then
      sketchybar --set bluetooth.status label='Unable to change Bluetooth'
      exit 1
    fi
    ;;
esac
source "$CONFIG_DIR/plugins/common.sh"
handle_popup bluetooth "${1:-}" || exit 0
# Bound queries while macOS Bluetooth permission is pending.
query_bluetooth() {
  local result query_pid attempt
  result=$(mktemp -t sketchybar-bluetooth) || return 1
  blueutil "$@" > "$result" 2>/dev/null &
  query_pid=$!
  for attempt in 1 2 3 4 5; do
    kill -0 "$query_pid" 2>/dev/null || break
    /bin/sleep 1
  done
  if kill -0 "$query_pid" 2>/dev/null; then
    kill "$query_pid" 2>/dev/null
  fi
  wait "$query_pid" 2>/dev/null
  local query_status=$?
  cat "$result"
  rm -f "$result"
  return "$query_status"
}
power=$(query_bluetooth --power)
case "$power" in
  1) status='Bluetooth: On'; action='Turn Bluetooth Off' ;;
  0) status='Bluetooth: Off'; action='Turn Bluetooth On' ;;
  *) status='Bluetooth unavailable — check permissions'; action='Toggle Bluetooth' ;;
esac
sketchybar --set bluetooth icon.color="$TEXT" \
  --set bluetooth.status label="$status" \
  --set bluetooth.toggle label="$action"

# Rebuild informational rows; device names are arguments, never shell code.
sketchybar --remove '/^bluetooth[.]device[.]/'
if [ "$power" = 1 ]; then
  if devices=$(query_bluetooth --connected --format json) && \
    printf '%s' "$devices" | /usr/bin/jq -e 'type == "array"' >/dev/null 2>&1; then
    count=$(printf '%s' "$devices" | /usr/bin/jq 'length')
    if [ "$count" -eq 0 ]; then
      sketchybar --set bluetooth.devices label='No connected devices'
    else
      sketchybar --set bluetooth.devices label='Connected devices'
      batteries=$(python3 "$CONFIG_DIR/helpers/bluetooth_batteries.py")
      index=0
      while IFS= read -r device; do
        sketchybar --add item "bluetooth.device.$index" popup.bluetooth \
          --set "bluetooth.device.$index" icon='' icon.color="$GREEN" \
          label="$device" icon.width=26 label.padding_left=14 label.padding_right=18
        index=$((index + 1))
      done < <(printf '%s' "$devices" | /usr/bin/jq -r --argjson battery "$batteries"         '.[] | (.name // .address) as $name | ($battery[.address] // $battery[$name] // "") as $level | if $level == "" then $name else "\($name) · \($level)" end | gsub("[\\r\\n]"; " ")')
    fi
  else
    sketchybar --set bluetooth.devices label='Unable to read connected devices'
  fi
else
  sketchybar --set bluetooth.devices label='No connected devices'
fi
