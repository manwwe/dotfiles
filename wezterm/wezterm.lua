local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.initial_cols = 207
config.initial_rows = 50
config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.default_cursor_style = "BlinkingBar"
config.color_scheme = "Gruvbox Dark (Gogh)"
config.font = wezterm.font("RobotoMono Nerd Font", { weight = "Bold" })
config.font_size = 15

config.window_padding = {
	left = 3,
	right = 3,
	top = 10,
	bottom = 7.5,
}

return config
