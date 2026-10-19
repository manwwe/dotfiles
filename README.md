# Dotfiles

Personal development environment configuration, organized by tool and centered on a macOS terminal workflow.

## Structure

```text
.
├── agents/              # Codex local config, guidance and installed skills
├── ascii_art/           # Terminal art used by fastfetch
├── editors/             # Shared editor defaults (.editorconfig)
├── ghostty/             # Ghostty terminal config
├── git/                 # Global git config and ignore rules
├── lazygit/             # Lazygit UI and keybinding tweaks
├── lf/                  # lf file manager config and icons
├── sqruff/              # SQL formatting/lint config
├── starship/            # Shell prompt theme
├── tmux/                # Tmux session and statusline config
├── wezterm/             # WezTerm modules and key/mouse behavior
├── zed/                 # Zed editor settings and keymap
├── zsh/                 # Shell startup, aliases and plugin setup
└── README.md
```

## Highlights

- `ghostty/config`: minimal terminal setup with split navigation, clipboard shortcuts and borderless window styling.
- `tmux/.tmux.conf`: `C-s` prefix, Vim-style pane movement, popup session switcher with `fzf`, and Catppuccin statusline.
- `zsh/.zshrc`: Zinit plugin bootstrap, directory shortcuts, Docker/Kubernetes/Git aliases, `fzf`, `zoxide`, `starship`, and `fastfetch`.
- `starship/starship.toml`: prompt segments for directory, git, language runtimes and time.
- `lazygit/config.yaml`: custom navigation, `delta` paging, and `gh browse` shortcuts.
- `zed/.config/zed/`: clean Zed settings and keymap for a Vim-oriented workflow.
- `agents/`: local Codex agent rules plus bundled skills such as `git-commit`, `brainstorming`, `systematic-debugging`, and `interface-design`.

## Notes

- A Nerd Font is expected for terminal icons and prompt symbols.
- Some shell behavior assumes tools like `eza`, `fzf`, `zoxide`, `fastfetch`, `tmux`, `delta`, `gh`, and `kubectl` are installed.
- `fastfetch` uses [`ascii_art/snorlax.ans`](/Users/ender/repos/github/dotfiles/ascii_art/snorlax.ans).
- The repository includes both `Ghostty` and `WezTerm`, but the current terminal workflow is primarily documented through `ghostty/` and `tmux/`.

## Setup

There is no installer in this repository. The files are meant to be linked or copied into the expected locations manually, for example:

- `zsh/.zshrc` -> `~/.zshrc`
- `starship/starship.toml` -> `~/.config/starship.toml`
- `ghostty/config` -> `~/.config/ghostty/config`
- `zed/.config/zed/settings.json` -> `~/.config/zed/settings.json`
- `zed/.config/zed/keymap.json` -> `~/.config/zed/keymap.json`
- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `lazygit/config.yaml` -> `~/Library/Application Support/lazygit/config.yml` or `~/.config/lazygit/config.yml`

Adapt paths as needed for your own machine.

## SketchyBar (macOS)

Catppuccin Mocha bar with clickable AeroSpace workspaces 1–7, the active
application, battery with Nerd Font charge-level icons (hidden on desktops), and local date/time. Uses RobotoMono Nerd Font, with its Mono variant for calendar alignment.
Battery icons show each 10% level, with a dedicated charging icon whenever the charger is
connected, including when charging is paused. All use the standard text color; only levels at or below 10% turn red.
Click the Apple icon for Preferences (System Settings), Activity Monitor, and
Lock Screen. The lock action sends Control-Command-Q through System Events; macOS
may ask for Accessibility/Automation permission for SketchyBar.
Click the clock to toggle a monthly calendar popup; moving the pointer away from
the bar and popup dismisses it.
Configuration lives in `sketchybar/.config/sketchybar/`; edit `colors.sh` for colors.

```sh
brew install blueutil
brew install --cask font-roboto-mono-nerd-font
brew tap FelixKratz/formulae
brew trust --formula felixkratz/formulae/sketchybar # if Homebrew requires tap trust
brew install felixkratz/formulae/sketchybar
stow --simulate --verbose --target="$HOME" sketchybar
stow --target="$HOME" sketchybar
brew services start sketchybar
```

The AeroSpace package adds workspace-change notifications and a 40px top gap.
If `~/.aerospace.toml` already exists as a regular file, back it up and merge any
local changes before linking the package with `stow --target="$HOME" aerospace`.
Then run `aerospace reload-config`.

Enable “Displays have separate Spaces” in macOS settings. Set the native menu
bar to auto-hide if you want SketchyBar to replace it. On notched displays or
multiple monitors, adjust bar height and AeroSpace's top gap together as needed.

After edits, run `sketchybar --reload`. To debug, stop the service with
`brew services stop sketchybar` and run `sketchybar` in a terminal.
To remove the bar, stop its service, run `stow --delete --target="$HOME" sketchybar`,
and restore AeroSpace's original 5px top gap and remove its workspace callback.

The Bluetooth icon opens a popup with power status, connected device names, an on/off toggle, and Bluetooth
settings. Its icon matches the clock text color. It refreshes every 30 seconds and on wake. Allow Bluetooth access in
macOS Privacy & Security if prompted for SketchyBar/blueutil.

The active app has a Nerd Font icon for Firefox, ChatGPT/Codex, terminals, editors,
and common macOS apps, with a generic fallback. Add mappings in
`plugins/front_app.sh`. Neovim inside a terminal is detected when the window title
contains `nvim` or `Neovim` (enable a matching title in your Neovim config).

The Wi-Fi icon opens connection status, network name (when macOS permits it),
local IP, security type, and Wi-Fi Settings. It refreshes every 30 seconds and on
wake. Redacted SSIDs are shown as hidden rather than mistaken for disconnection.

A red microphone icon appears only while CoreAudio reports an active input stream
from an app, checked every two seconds. Requires macOS 14.2+ and Xcode Command
Line Tools; the small helper is compiled locally on bar startup. Its binary is
ignored by Git. This reads audio activity metadata without recording audio.

A green camera icon appears while CoreMediaIO reports a camera running anywhere on the system, checked every two seconds. It checks cameras exposed by CoreMediaIO without starting a capture session or recording video.
The helper is compiled locally alongside the microphone helper (macOS 14+).

The AI robot icon opens subscription quota windows for Codex, Claude, Copilot,
and Gemini via `brew install --cask codexbar`. Also requires Python 3. Existing
provider sign-ins are used (Codex/Claude OAuth and Copilot/Gemini API quota
sources). Missing authentication or unavailable quotas are shown explicitly.
Open CodexBar from the popup to configure providers; no API keys go in dotfiles.
Allowances show percent remaining and local reset times, refreshed every five
minutes. Click the last-checked row to force a refresh. Quota requests run in
parallel with 20-second deadlines; only display text is cached under
`~/Library/Caches/sketchybar-ai/`.

CPU and memory icons show usage percentages refreshed every five seconds. Click
either to open Activity Monitor. CPU is total utilization across cores over a
short sample. Memory is active + wired + physical compressor pages as a share
of physical RAM, excluding inactive cache; it is not macOS memory pressure.

The Pomodoro icon opens a 27-minute focus timer with start, pause/resume, and
reset. A countdown appears while running/paused; completion shows Done and plays
the macOS Glass sound once. State persists across bar reloads in
`~/Library/Caches/sketchybar-pomodoro/`; sleep time counts toward a running timer.
The separate “Run Start Pomodoro shortcut…” action runs your existing Apple
Shortcut, which asks for a duration and enables Do Not Disturb. Its native Clock
timer runs separately from the bar countdown. The bar timer itself does not alter Focus.

CPU, memory, AI quotas, and idle Pomodoro controls start collapsed behind a `` toggle.
Click to expand (``) or collapse; the preference survives bar reloads. Running
and paused Pomodoro countdowns remain visible when collapsed, as does Done until
reset. Timers continue updating while the controls are hidden.

Apple Music appears while Music is open, even if paused, and hides when it quits.
The bar shows a music icon and scrolling track title. Its popup includes song,
artist, album, previous/play-pause/next controls, and Open Apple Music. Metadata
refreshes on Music notifications and every five seconds. Allow Music automation
if prompted. Browser playback is not displayed or controlled. No playback starts
during bar setup.

## Controls, workspace apps, and setup

- Volume opens level/mute controls, ±5% steps, output-device selection, and Sound
  Settings. Requires `switchaudio-osx`. Volume updates use SketchyBar's
  `volume_change` event with a two-minute fallback; output lists refresh on open.
- Bluetooth rows show connected-device batteries when macOS reports them,
  including separate left/right/case readings. A standard CoreBluetooth Battery
  Service fallback reads supported BLE mice without scanning or pairing new devices,
  and caches readings for one minute. Devices without battery data show
  their name only; disconnected-device readings are excluded because they can be stale.
- AeroSpace uses centered numbered workspace badges. A single observer updates
  focus highlighting on workspace changes, with a 30-second fallback.
- The bell opens native Notification Center via the macOS clock menu item.
  Enable the native clock and allow Accessibility/Automation for System Events.
- Popup handlers share a serialized exclusive-open policy and consistent spacing,
  borders, and row heights; the calendar keeps its compact grid.
- Folded CPU stats stop polling and refresh immediately when expanded. Idle
  Pomodoro ticks no longer rewrite the state file or reapply group visibility.
  Music uses its events plus a 20-second fallback; calendar rows only rebuild on
  explicit refresh/open rather than every clock tick. Camera/microphone checks
  retain their two-second activity response.

From the repository root:

```sh
./scripts/setup-sketchybar.sh --check   # read-only dependencies + Stow dry run
./scripts/setup-sketchybar.sh --install # install dependencies, link, build, activate
```

Requires Homebrew and Xcode Command Line Tools. Existing conflicting regular files
are reported by Stow and are never overwritten; back up/merge them before retrying.
The installer includes AeroSpace, SketchyBar, the font, Python, blueutil,
switchaudio-osx, and CodexBar. Provider sign-ins and macOS privacy permissions stay
interactive. Helpers compile locally; no generated binaries belong in Git.

The Apple popup also includes Sleep, Restart, and Shut Down. Restart and Shut Down
ask for confirmation before executing; Cancel is the default.

The Music popup shows cached 128px album artwork when available from Apple Music.
Tracks without artwork hide the cover row; no image is downloaded separately.
