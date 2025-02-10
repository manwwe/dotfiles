return {
  "christoomey/vim-tmux-navigator",
  opts = {},
  config = function()
    vim.g.tmux_navigator_no_mappings = 1

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", opts)
    vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", opts)
    vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", opts)
    vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", opts)
  end,
}
