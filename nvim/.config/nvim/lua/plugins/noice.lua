-- Configuration for the noice.nvim plugin
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- Add options here
    background_colour = "#1e1e2e",
    render = "minimal",
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    -- Load noice.nvim options
    require("noice").setup({
      background_colour = "#1e1e2e",
      render = "minimal",
    })

    -- Define the highlight group 'NotifyBackground' with a background color
    vim.cmd([[
      highlight NotifyBackground guibg=#1e1e2e
    ]])
  end,
}
