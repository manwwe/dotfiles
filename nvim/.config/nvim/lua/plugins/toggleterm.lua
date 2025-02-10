-- Terminal toggling and management
return {
  "akinsho/toggleterm.nvim",
  opts = {
    -- Configuration options for toggleterm
    size = 20, -- Default size of the terminal window
    open_mapping = [[<C-t>]], -- Keybinding to toggle the terminal
    hide_numbers = true, -- Hide line numbers in the terminal
    shade_filetypes = {}, -- Filetypes to exclude from shading
    shade_terminals = true, -- Enable terminal shading
    shading_factor = 2, -- Shading intensity (1 = light, 3 = dark)
    start_in_insert = true, -- Start terminal in insert mode
    persist_size = true, -- Remember terminal size
    direction = "float", -- Terminal layout: 'vertical', 'horizontal', or 'float'
    float_opts = {
      border = "curved", -- Border style for floating terminal
      winblend = 0, -- Transparency of the floating terminal
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Custom keymaps for terminal mode
    local opts = { noremap = true, silent = true }
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts) -- Exit terminal mode with Esc
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts) -- Move to left window
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts) -- Move to below window
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts) -- Move to above window
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts) -- Move to right window
  end,
}
