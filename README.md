# Dotfiles

This repository contains my personal configuration files (“dotfiles”) for tools I use every day as a developer.  
The setup is structured by tool, and it’s optimized for macOS and WSL (Windows Subsystem for Linux).

## 📁 Structure

```

├── editors
│   └── .editorconfig          # Editor settings (indentation, charset, etc.)
├── git
│   └── .gitignore\_global      # Global git ignore rules
├── lf
│   ├── icons                  # Custom icons for lf file manager (requires Nerd Font)
│   └── lfrc                   # lf configuration file
├── starship
│   └── starship.toml          # Starship prompt configuration
├── wezterm
│   ├── macos\_config.lua       # WezTerm config for macOS
│   ├── wezterm.lua            # Main WezTerm config
│   └── wsl\_config.lua         # WezTerm config for WSL
├── zsh
│   ├── .zshrc                 # Main Zsh configuration
│   └── .zshrc\_wsl             # Extra settings for Zsh under WSL
├── .gitignore                 # Ignore rules for this repository
└── README.md                  # This file

```

## ℹ️ About

- **editors/**: Settings for consistent editor behavior across VSCode, Vim, and other editors that support `.editorconfig`.
- **git/**: Global `.gitignore` for ignoring common files and directories across all repos.
- **lf/**: Custom configuration and icons for the [lf file manager](https://github.com/gokcehan/lf).
- **starship/**: [Starship](https://starship.rs/) prompt configuration for a minimal, informative shell prompt.
- **wezterm/**: Separate WezTerm terminal emulator configs for macOS, WSL, and general use.
- **zsh/**: Shell configuration, including an extra file for settings specific to WSL environments.

## 📝 Notes

- These dotfiles are tailored for my workflow and might need adjustments for other setups.
- You’ll need a [Nerd Font](https://www.nerdfonts.com/) installed for some icons to display correctly.
- Most files are symlinked into my `$HOME` directory using a custom install script (not included here).

---

Feel free to use or adapt anything here for your own setup.
