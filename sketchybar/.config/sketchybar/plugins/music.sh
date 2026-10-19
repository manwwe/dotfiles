#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$CONFIG_DIR/plugins/common.sh"
handle_popup music "${1:-}" || exit 0
python3 "$CONFIG_DIR/helpers/music.py" "${1:-}"
