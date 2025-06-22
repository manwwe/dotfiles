-- ~/.config/wezterm/wsl_config.lua
local wezterm = require("wezterm")

local module = {}

function module.apply_to_config(config)
	-- WSL-specific settings
	config.font = wezterm.font("FiraCode Nerd Font", { weight = "Medium" })
	config.font_size = 13
	config.window_background_opacity = 0.85
	-- Add any WSL tweaks here
end

return module
