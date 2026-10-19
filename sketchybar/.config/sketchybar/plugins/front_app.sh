#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
if [ "${SENDER:-}" = front_app_switched ]; then
  app="$INFO"
else
  app=$(/usr/bin/lsappinfo info -only name "$(/usr/bin/lsappinfo front)" 2>/dev/null | /usr/bin/sed -n 's/^"LSDisplayName"="\(.*\)"$/\1/p')
fi
app="${app:-Desktop}"
case "$app" in
  Firefox*) icon='󰈹' ;;
  Safari) icon='' ;;
  'Google Chrome'*) icon='' ;;
  ChatGPT) icon='' ;;
  Codex) icon='󰚩' ;;
  Neovim|neovim|nvim|MacVim) icon='' ;;
  Ghostty|Terminal|iTerm2|WezTerm|Alacritty|kitty)
    icon=''
    [ "$app" = Ghostty ] && icon='󰊠'
    # Neovim runs inside a terminal: recognize it when its window title says so.
    title=$(aerospace list-windows --focused --format '%{window-title}' 2>/dev/null)
    case "$title" in
      *[Nn][Vv][Ii][Mm]*|*[Nn][Ee][Oo][Vv][Ii][Mm]*|*' - VIM'*)
        icon=''; app='Neovim' ;;
    esac
    ;;
  Zed) icon='' ;;
  'Visual Studio Code'|'Code') icon='' ;;
  Obsidian|obsidian) icon='' ;;
  Finder) icon='󰉋' ;;
  'System Settings'|'System Preferences') icon='' ;;
  'Activity Monitor') icon='' ;;
  Music|Spotify) icon='' ;;
  Slack|Discord) icon='' ;;
  Docker*) icon='' ;;
  Preview) icon='' ;;
  Mail) icon='' ;;
  Calendar) icon='' ;;
  Notes) icon='' ;;
  *) icon='' ;;
esac
sketchybar --set "$NAME" icon="$icon" icon.drawing=on label="$app"
