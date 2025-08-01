local wezterm = require("wezterm") --[[@as Wezterm]]
local config = wezterm.config_builder()

local padding = {
  left = '1cell',
  right = '3cell',
  top = '0.5cell',
  bottom = '0.5cell',
}

require("tabs").setup(config)
require("links").setup(config)
require("keys").setup(config)

wezterm.log_info("reloading")

-- Font
config.font                       = wezterm.font("FiraCode Nerd Font", { weight = "Regular" })
config.font_size                  = 14

-- Appearance
config.color_scheme               = "Catppuccin Frappe"
-- config.window_background_opacity = 0.9
config.cell_width                 = 0.95
config.scrollback_lines           = 10000
config.window_decorations         = "RESIZE"
-- config.window_content_alignment   = {
--   horizontal = 'Center',
--   vertical = 'Bottom',
-- }

-- Performance
config.webgpu_power_preference    = "HighPerformance"
config.enable_kitty_graphics      = true
config.window_close_confirmation  = 'NeverPrompt'

-- Scrolling
config.underline_thickness        = 3
config.cursor_thickness           = 4
config.underline_position         = -6

-- Cursor
config.default_cursor_style       = "BlinkingBar"
config.force_reverse_video_cursor = true
config.cursor_blink_ease_in       = "Constant"
config.cursor_blink_ease_out      = "Constant"

-- GUI startup
wezterm.on("gui-startup", function(cmd)
  local screen              = wezterm.gui.screens().active
  local _tab, _pane, window = wezterm.mux.spawn_window(cmd or {})
  local gui                 = window:gui_window()
  local width               = 0.97 * screen.width
  local height              = 0.97 * screen.height

  gui:set_inner_size(width, height)
  gui:set_position(
    (screen.width - width) / 2,
    (screen.height - height) / 2
  )
end)

-- Custom padding for Neovim
-- This will remove padding when Neovim is the active pane
-- and apply normal padding for other processes.
-- This is useful to avoid unnecessary padding in Neovim.
local function is_nvim(pane)
  local process_info = pane:get_foreground_process_info()
  if not process_info then
    return false
  end
  local process_name = process_info.name:lower()
  return process_name:find('n?vim') ~= nil
end

local function update_padding(window, pane)
  local overrides = window:get_config_overrides() or {}

  if is_nvim(pane) then
    -- With Neovim, remove padding
    overrides.window_padding = {
      left = 7,
      right = 1,
      top = 25,
      bottom = 0,
    }
  else
    -- Normal padding for other processes
    overrides.window_padding = padding
  end

  window:set_config_overrides(overrides)
end

-- Update padding when the window gains or loses focus
wezterm.on('window-focus-changed', function(window, pane)
  if pane then
    update_padding(window, pane)
  end
end)

-- Update padding when the active pane changes
wezterm.on('pane-focus-changed', function(window, pane)
  update_padding(window, pane)
end)

-- Update padding periodically (every 500ms) to capture process changes
wezterm.on('update-status', function(window, pane)
  update_padding(window, pane)
end)

return config
