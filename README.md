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
├── zsh/                 # Shell startup, aliases and plugin setup
└── README.md
```

## Highlights

- `ghostty/config`: minimal terminal setup with split navigation, clipboard shortcuts and borderless window styling.
- `tmux/.tmux.conf`: `C-s` prefix, Vim-style pane movement, popup session switcher with `fzf`, and Catppuccin statusline.
- `zsh/.zshrc`: Zinit plugin bootstrap, directory shortcuts, Docker/Kubernetes/Git aliases, `fzf`, `zoxide`, `starship`, and `fastfetch`.
- `starship/starship.toml`: prompt segments for directory, git, language runtimes and time.
- `lazygit/config.yaml`: custom navigation, `delta` paging, and `gh browse` shortcuts.
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
- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `lazygit/config.yaml` -> `~/Library/Application Support/lazygit/config.yml` or `~/.config/lazygit/config.yml`

Adapt paths as needed for your own machine.
