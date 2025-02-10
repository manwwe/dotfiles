-- Explore and navigate the structure of the current file
return {
  "preservim/tagbar",
  opts = {}, -- No extensive configuration needed
  config = function()
    -- Automatically focus on the Tagbar window when opened
    vim.g.tagbar_autofocus = 1
    -- Set the default width of the Tagbar window
    vim.g.tagbar_width = 30

    -- Keymaps for Tagbar
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<F8>", ":TagbarToggle<CR>", opts) -- Toggle Tagbar
  end,
}
