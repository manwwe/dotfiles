-- Configuración para el plugin nvim-notify
return {
  "rcarriga/nvim-notify",
  config = function()
    -- Configurar nvim-notify con el color de fondo
    require("notify").setup({
      background_colour = "#1e1e2e",
      stages = "slide",
      timeout = 3000,
      top_down = false,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    })
  end,
}
