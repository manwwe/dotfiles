return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local mode = {
      "mode",
      fmt = function(str)
        return " " .. str
      end,
    }

    local filename = {
      "filename",
      file_status = true,
      path = 0,
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_lsp" },
      sections = { "error", "warn" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      colored = false,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      "diff",
      colored = false,
      symbols = { added = " ", modified = " ", removed = " " },
      cond = hide_in_width,
    }

    local lsp_status = function()
      local buf_ft = vim.bo.filetype
      local clients = vim.lsp.get_clients()
      local lsps = {}
      for _, client in pairs(clients) do
        if client.config.filetypes and vim.tbl_contains(client.config.filetypes, buf_ft) then
          table.insert(lsps, client.name)
        end
      end
      if next(lsps) ~= nil then
        return "LSP: " .. table.concat(lsps, ", ")
      else
        return "LSP Inactive"
      end
    end

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "nord",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "|" },
        disabled_filetypes = { "alpha", "neo-tree" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { "branch" },
        lualine_c = { filename },
        lualine_x = { diagnostics, diff, { "encoding", cond = hide_in_width }, { "filetype", cond = hide_in_width } },
        lualine_y = { "location", lsp_status },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { { "location", padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "fugitive" },
    })
  end,
}
