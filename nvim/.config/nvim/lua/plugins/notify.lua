-- Configuración para el plugin nvim-notify
return {
  "rcarriga/nvim-notify",
  config = function()
    -- Configurar nvim-notify con el color de fondo
    require("notify").setup({
      background_colour = "#1e1e2e",
    })
  end,
}
