-- Import the wezterm API
local wezterm = require("wezterm")

-- Create a configuration builder object
local config = wezterm.config_builder()

-- Import the multiplexer API
local mux = wezterm.mux

-- Import the tabline plugin from a GitHub repository
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- Maximize the window on GUI startup
wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- Default settings configuration
config.color_scheme = "catppuccin-frappe" -- Set the color scheme
config.automatically_reload_config = true -- Automatically reload the configuration when changes are detected
config.tab_bar_at_bottom = true -- Display the tab bar at the bottom
config.use_fancy_tab_bar = false -- Disable the fancy tab bar
config.show_new_tab_button_in_tab_bar = false -- Hide the new tab button in the tab bar
config.tab_max_width = 999 -- Set the maximum width of tabs
config.show_new_tab_button_in_tab_bar = true

-- Key bindings configuration
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "|",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
}

local num_icons = {
	[0] = wezterm.nerdfonts.md_numeric_0_box_multiple_outline,
	[1] = wezterm.nerdfonts.md_numeric_1_box_multiple_outline,
	[2] = wezterm.nerdfonts.md_numeric_2_box_multiple_outline,
	[3] = wezterm.nerdfonts.md_numeric_3_box_multiple_outline,
	[4] = wezterm.nerdfonts.md_numeric_4_box_multiple_outline,
	[5] = wezterm.nerdfonts.md_numeric_5_box_multiple_outline,
	[6] = wezterm.nerdfonts.md_numeric_6_box_multiple_outline,
	[7] = wezterm.nerdfonts.md_numeric_7_box_multiple_outline,
	[8] = wezterm.nerdfonts.md_numeric_8_box_multiple_outline,
	[9] = wezterm.nerdfonts.md_numeric_9_box_multiple_outline,
}
-- Apply the tabline plugin with default options
tabline.setup({
	options = {
		theme = "Grayscale (dark) (terminal.sexy)",
		theme_overrides = {
			normal_mode = {
				b = { bg = "#393E46", fg = "#9AA6B2" },
			},
			tab = {
				active = { fg = "#EFEFEF", bg = "#222831" },
				inactive = { fg = "#393E46" },
			},
		},
		icons_enabled = true,
		tabs_enabled = true,
		section_separators = {
			left = "",
			right = "",
		},
		component_separators = {
			left = "",
			right = "",
		},
		tab_separators = {
			left = "",
			right = "█",
		},
	},
	sections = {
		tabline_a = {},
		tabline_b = {},
		tabline_c = {},
		tab_active = {
			{
				"index",
				zero_indexed = false,
				fmt = function(str)
					local num = tonumber(str)
					return num_icons[num] or str
				end,
				padding = { right = 1 }, -- Espacio entre el icono y el nombre
			},
			{ "process", padding = { left = 0, right = 1 } },
		},
		tab_inactive = {
			{
				"index",
				zero_indexed = false,
				fmt = function(str)
					local num = tonumber(str)
					return num_icons[num] or str
				end,
				padding = { right = 1 },
			},
			{ "process", padding = { left = 0, right = 1 } },
		},
		tabline_x = { "ram", "cpu" },
		tabline_y = { "datetime", "battery" },
		tabline_z = { "domain" },
	},
	extensions = {}, -- No extensions configured
})

-- Detect platforms
local is_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil -- Check if running in WSL
local is_macos = wezterm.target_triple:find("apple") or wezterm.target_triple:find("darwin") -- Check if running on macOS

-- Apply platform-specific configurations
if is_macos then
	require("macos_config").apply_to_config(config) -- Apply macOS-specific configuration
elseif is_wsl then
	require("wsl_config").apply_to_config(config) -- Apply WSL-specific configuration
end

-- Return the final configuration
return config
