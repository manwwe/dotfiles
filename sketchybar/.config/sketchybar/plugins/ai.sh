#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
case "${1:-}" in
  settings)
    sketchybar --set ai popup.drawing=off
    /usr/bin/open -a CodexBar
    exit $?
    ;;
esac
source "$CONFIG_DIR/plugins/common.sh"
handle_popup ai "${1:-}" || exit 0
python3 "$CONFIG_DIR/helpers/ai_quotas.py" "${1:-}"
