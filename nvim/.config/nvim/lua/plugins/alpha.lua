return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Adds icons support to the dashboard
  },

  config = function()
    local alpha = require("alpha") -- Load alpha-nvim
    local dashboard = require("alpha.themes.dashboard") -- Load the dashboard theme

    -- Set the header (ASCII art or text)
    dashboard.section.header.val = {
      [[                                                    ]],
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
      [[                                                    ]],
    }

    -- Configure the layout to center the content
    dashboard.opts.layout = {
      { type = "padding", val = 5 }, -- Add 5 empty lines at the top (to center vertically)
      dashboard.section.header, -- Display the header (ASCII art)
      { type = "padding", val = 2 }, -- Add 2 lines of padding after the header
      dashboard.section.buttons, -- Placeholder for buttons (can be customized later)
      dashboard.section.footer, -- Placeholder for footer text
    }

    -- Apply the configuration to alpha
    alpha.setup(dashboard.opts)
  end,
}
