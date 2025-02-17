return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons", -- Opcional, para iconos en la vista
  },
  opts = { -- Configuración correcta dentro de `opts`
    show_guides = true,
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top = "│ ",
      whitespace = "  ",
    },
    layout = {
      max_width = { 40, 0.3 }, -- Máximo 40 columnas o 30% del ancho de la ventana
      width = nil,
      default_direction = "prefer_left", -- Abre a la derecha si hay espacio
    },
    keymaps = {
      ["{"] = "prev", -- Saltar al símbolo anterior
      ["}"] = "next", -- Saltar al siguiente símbolo
      ["<CR>"] = "jump", -- Ir al símbolo seleccionado
      ["o"] = "jump",
      ["q"] = "close",
    },
  },
  -- Keymap to toggle Aerial with <Leader>a
  vim.keymap.set("n", "<Leader>a", ":AerialToggle<CR>", { noremap = true, silent = true, desc = "Toggle Aerial" }),
}
