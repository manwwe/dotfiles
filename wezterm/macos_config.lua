-- ~/.config/wezterm/macos_config.lua
local wezterm = require("wezterm")

local module = {}

function module.apply_to_config(config)
	config.font = wezterm.font("RobotoMono Nerd Font", { weight = "Regular" })
	config.font_size = 15
	config.default_cursor_style = "BlinkingBar"
	config.window_decorations = "TITLE | RESIZE"
	config.window_padding = {
		left = 5,
		right = 3,
		top = 0,
		bottom = 0,
	}
end
return module
