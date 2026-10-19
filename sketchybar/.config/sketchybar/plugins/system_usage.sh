#!/bin/bash
usage=$("$CONFIG_DIR/helpers/system_usage") || exit 1
read -r cpu memory <<< "$usage"
sketchybar --set cpu label="$cpu%" --set memory label="$memory%"
