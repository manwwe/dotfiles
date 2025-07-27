local wezterm = require("wezterm") --[[@as Wezterm]]
local config = wezterm.config_builder()

require("tabs").setup(config)
require("links").setup(config)
require("keys").setup(config)

wezterm.log_info("reloading")

-- Font
config.color_scheme = "Catppuccin Macchiato"
config.font        = wezterm.font("FiraCode Nerd Font", { weight = "Regular" })
config.font_size   = 14

-- Appearance
config.color_scheme             = "tokyonight_night"
config.window_background_opacity = 0.9
config.cell_width                = 1
config.scrollback_lines          = 10000
config.window_decorations        = "RESIZE"

-- Performance
-- config.webgpu_power_preference = "HighPerformance"
-- config.enable_kitty_graphics   = true

-- Scrolling
config.underline_thickness = 3
config.cursor_thickness    = 4
config.underline_position  = -6

-- Cursor
config.default_cursor_style     = "BlinkingBar"
config.force_reverse_video_cursor = true
config.cursor_blink_ease_in     = "Constant"
config.cursor_blink_ease_out    = "Constant"

-- GUI startup
wezterm.on("gui-startup", function(cmd)
  local screen             = wezterm.gui.screens().active
  local _tab, _pane, window = wezterm.mux.spawn_window(cmd or {})
  local gui                = window:gui_window()
  local width              = 0.97 * screen.width
  local height             = 0.97 * screen.height

  gui:set_inner_size(width, height)
  gui:set_position(
    (screen.width  - width)  / 2,
    (screen.height - height) / 2
  )
end)

return config
