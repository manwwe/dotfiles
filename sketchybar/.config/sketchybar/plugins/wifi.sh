#!/bin/bash
source "$CONFIG_DIR/colors.sh"
if [ "${1:-}" = settings ]; then
  sketchybar --set wifi popup.drawing=off
  /usr/bin/open 'x-apple.systempreferences:com.apple.wifi-settings-extension'
  exit $?
fi
source "$CONFIG_DIR/plugins/common.sh"
handle_popup wifi "${1:-}" || exit 0
interface=$(/usr/sbin/networksetup -listallhardwareports 2>/dev/null | \
  /usr/bin/awk '/Hardware Port: (Wi-Fi|AirPort)/ {getline; print $2; exit}')
status='Wi-Fi unavailable'
network='Network: —'
ip='IP: —'
security='Security: —'
icon='󰖪'
color="$MUTED"
if [ -n "$interface" ]; then
  power=$(/usr/sbin/networksetup -getairportpower "$interface" 2>/dev/null)
  summary=$(/usr/sbin/ipconfig getsummary "$interface" 2>/dev/null)
  case "$power" in
    *': Off') status='Wi-Fi: Off' ;;
    *)
      if printf '%s\n' "$summary" | /usr/bin/grep -q 'LinkStatusActive : TRUE'; then
        status='Wi-Fi: Connected'
        icon=''
        color="$TEXT"
        ssid=$(printf '%s\n' "$summary" | /usr/bin/awk -F ' SSID : ' '/ SSID : / {print $2; exit}')
        case "$ssid" in
          ''|*redacted*) network='Network name hidden by macOS' ;;
          *) network="Network: $ssid" ;;
        esac
        address=$(/usr/sbin/ipconfig getifaddr "$interface" 2>/dev/null)
        ip="IP: ${address:-—}"
        mode=$(printf '%s\n' "$summary" | /usr/bin/awk -F ' Security : ' '/ Security : / {print $2; exit}')
        security="Security: ${mode:-Unknown}"
      else
        status='Wi-Fi: Disconnected'
      fi
      ;;
  esac
fi
sketchybar --set wifi icon="$icon" icon.color="$color" \
  --set wifi.status label="$status" \
  --set wifi.network label="$network" \
  --set wifi.ip label="$ip" \
  --set wifi.security label="$security"
