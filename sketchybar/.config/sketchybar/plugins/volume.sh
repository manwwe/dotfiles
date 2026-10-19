#!/bin/bash
source "$CONFIG_DIR/plugins/common.sh"
handle_popup volume "${1:-}" || exit 0
python3 "$CONFIG_DIR/helpers/volume.py" "$@"
