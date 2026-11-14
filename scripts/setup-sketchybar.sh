#!/bin/bash
# Usage: ./scripts/setup-sketchybar.sh --check | --install
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
MODE=${1:---check}
if [[ "$MODE" != --check && "$MODE" != --install ]]; then
  echo 'Usage: setup-sketchybar.sh [--check|--install]' >&2; exit 2
fi
if [[ $(uname -s) != Darwin ]]; then echo 'This setup requires macOS.' >&2; exit 1; fi
if ! command -v brew >/dev/null; then echo 'Install Homebrew first: https://brew.sh' >&2; exit 1; fi
if ! xcrun --find clang >/dev/null 2>&1; then echo 'Install Xcode Command Line Tools: xcode-select --install' >&2; exit 1; fi
if [[ "$MODE" = --install ]]; then
  brew install stow blueutil switchaudio-osx python@3.13
  if ! command -v aerospace >/dev/null; then
    brew tap nikitabobko/tap
    if brew help trust >/dev/null 2>&1; then brew trust --cask nikitabobko/tap/aerospace; fi
    brew install --cask nikitabobko/tap/aerospace
  fi
  brew install --cask font-roboto-mono-nerd-font codexbar
  if ! command -v sketchybar >/dev/null; then
    brew tap FelixKratz/formulae
    # Homebrew versions with tap trust require explicit formula trust.
    if brew help trust >/dev/null 2>&1; then brew trust --formula felixkratz/formulae/sketchybar; fi
    brew install felixkratz/formulae/sketchybar
  fi
fi
missing=0
for tool in stow sketchybar blueutil SwitchAudioSource python3 aerospace codexbar; do
  if ! command -v "$tool" >/dev/null; then echo "Missing dependency: $tool" >&2; missing=1; fi
done
if ! brew list --cask font-roboto-mono-nerd-font >/dev/null 2>&1; then
  echo 'Missing dependency: RobotoMono Nerd Font' >&2; missing=1
fi
if [[ "$missing" = 1 ]]; then echo 'Run --install; install AeroSpace separately if missing.' >&2; exit 1; fi
# Check both packages together before modifying any home-directory links.
stow --dir="$ROOT" --target="$HOME" --simulate --verbose --restow sketchybar aerospace
if [[ "$MODE" = --check ]]; then echo 'Dependencies and Stow conflict check passed.'; exit 0; fi
stow --dir="$ROOT" --target="$HOME" --restow sketchybar aerospace
CONFIG="$ROOT/sketchybar/.config/sketchybar"
clang -O2 -Wall -Wextra "$CONFIG/helpers/mic_status.c" -framework CoreAudio -o "$CONFIG/helpers/mic_status"
clang -O2 -Wall -Wextra -fobjc-arc "$CONFIG/helpers/camera_status.m" -framework CoreMediaIO -o "$CONFIG/helpers/camera_status"
clang -O2 -Wall -Wextra "$CONFIG/helpers/system_usage.c" -o "$CONFIG/helpers/system_usage"
clang -O2 -Wall -Wextra -fobjc-arc "$CONFIG/helpers/bluetooth_battery.m" -framework Foundation -framework CoreBluetooth -o "$CONFIG/helpers/bluetooth_battery"
clang -O2 -Wall -Wextra -fobjc-arc "$CONFIG/helpers/world_clock.m" -framework AppKit -o "$CONFIG/helpers/world_clock"
clang -O2 -Wall -Wextra -fobjc-arc "$CONFIG/helpers/calendar_popup.m" -framework AppKit -o "$CONFIG/helpers/calendar_popup"
clang -O2 -fobjc-arc "$CONFIG/helpers/agenda.m" -framework EventKit -framework Foundation -sectcreate __TEXT __info_plist "$CONFIG/helpers/agenda.plist" -o "$CONFIG/helpers/agenda"
brew services restart felixkratz/formulae/sketchybar
if aerospace list-workspaces --focused >/dev/null 2>&1; then aerospace reload-config; fi
echo 'SketchyBar activated. Allow Bluetooth and Music automation if prompted.'
echo 'Notification Center and Lock Screen shortcuts require Accessibility permission.'
