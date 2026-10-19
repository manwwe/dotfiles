# Shared event handling. Arguments on child rows must never toggle their parent.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
handle_popup() {
  local parent="$1" action="${2:-}"
  case "${SENDER:-}" in
    mouse.clicked)
      [ -n "$action" ] || python3 "$CONFIG_DIR/helpers/popup.py" "$parent"
      ;;
    mouse.exited.global)
      sketchybar --set "$parent" popup.drawing=off
      return 1
      ;;
  esac
  return 0
}
