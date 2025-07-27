local wezterm = require("wezterm") --[[@as Wezterm]]
local M = {}
M.arrow_solid = ""
M.arrow_thin = ""
M.icons = {
 ["C:\\WINDOWS\\system32\\cmd.exe"] = wezterm.nerdfonts.md_console_line,
 ["Topgrade"] = wezterm.nerdfonts.md_rocket_launch,
 ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
 ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
 ["cargo"] = wezterm.nerdfonts.dev_rust,
 ["curl"] = wezterm.nerdfonts.mdi_flattr,
 ["docker"] = wezterm.nerdfonts.linux_docker,
 ["docker-compose"] = wezterm.nerdfonts.linux_docker,
 ["fish"] = wezterm.nerdfonts.md_fish,
 ["gh"] = wezterm.nerdfonts.dev_github_badge,
 ["git"] = wezterm.nerdfonts.dev_git,
 ["go"] = wezterm.nerdfonts.seti_go,
 ["htop"] = wezterm.nerdfonts.md_chart_areaspline,
 ["btop"] = wezterm.nerdfonts.md_chart_areaspline,
 ["kubectl"] = wezterm.nerdfonts.linux_docker,
 ["kuberlr"] = wezterm.nerdfonts.linux_docker,
 ["lazydocker"] = wezterm.nerdfonts.linux_docker,
 ["lua"] = wezterm.nerdfonts.seti_lua,
 ["make"] = wezterm.nerdfonts.seti_makefile,
 ["node"] = wezterm.nerdfonts.mdi_hexagon,
 ["nvim"] = wezterm.nerdfonts.custom_vim,
 ["pacman"] = "󰮯 ",
 ["paru"] = "󰮯 ",
 ["psql"] = wezterm.nerdfonts.dev_postgresql,
 ["pwsh.exe"] = wezterm.nerdfonts.md_console,
 ["ruby"] = wezterm.nerdfonts.cod_ruby,
 ["sudo"] = wezterm.nerdfonts.fa_hashtag,
 ["vim"] = wezterm.nerdfonts.dev_vim,
 ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
 ["zsh"] = wezterm.nerdfonts.dev_terminal,
 ["lazygit"] = wezterm.nerdfonts.cod_github,
}

---@param tab MuxTabObj
---@param tab_index number
---@param max_width number
function M.title(tab, tab_index, max_width)
    -- Obtener título original
    local original_title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title

    -- Extraer el proceso del título
    local process, other = original_title:match("^(%S+)%s*%-?%s*%s*(.*)$")

    -- Construir el título con número del tab
    local tab_number = tostring(tab_index -1)
    local display_title = original_title

    -- Si encontramos un icono para el proceso, lo usamos
    if process and M.icons[process] then
        icon = M.icons[process] .. " "
        -- Si hay información adicional, la usamos; si no, usamos el proceso
        display_title = other and #other > 0 and other or process
    end

    -- Formato: [número] [icono] título
    local full_title = tab_number .. " " .. icon .. display_title

    -- Verificar si hay panes con zoom
    local is_zoomed = false
    for _, pane in ipairs(tab.panes) do
        if pane.is_zoomed then
            is_zoomed = true
            break
        end
    end

    -- Agregar indicador de zoom si es necesario
    if is_zoomed then
        full_title = " " .. full_title
    end

    -- Truncar si es necesario
    full_title = wezterm.truncate_right(full_title, max_width)

    return " " .. full_title .. " "
end

---@param config Config
function M.setup(config)
    config.use_fancy_tab_bar = false
    config.tab_bar_at_bottom = true
    config.hide_tab_bar_if_only_one_tab = true
    config.tab_max_width = 50
    config.unzoom_on_switch_pane = true

    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        -- Encontrar el índice del tab actual
        local tab_idx = 1
        for i, t in ipairs(tabs) do
            if t.tab_id == tab.tab_id then
                tab_idx = i
                break
            end
        end

        -- Generar el título con número e icono
        local title = M.title(tab, tab_idx, max_width)

        local colors = config.resolved_palette
        local active_bg = colors.tab_bar.active_tab.bg_color
        local inactive_bg = colors.tab_bar.inactive_tab.bg_color

        local is_last = tab_idx == #tabs
        local next_tab = tabs[tab_idx + 1]
        local next_is_active = next_tab and next_tab.is_active
        local arrow = (tab.is_active or is_last or next_is_active) and M.arrow_solid or M.arrow_thin
        local arrow_bg = inactive_bg
        local arrow_fg = colors.tab_bar.inactive_tab_edge

        if is_last then
            arrow_fg = tab.is_active and active_bg or inactive_bg
            arrow_bg = colors.tab_bar.background
        elseif tab.is_active then
            arrow_bg = inactive_bg
            arrow_fg = active_bg
        elseif next_is_active then
            arrow_bg = active_bg
            arrow_fg = inactive_bg
        end

        local ret = tab.is_active
            and {
                -- { Attribute = { Intensity = "Bold" } },
                { Attribute = { Italic = true } },
            }
            or {}

        ret[#ret + 1] = { Text = title }
        ret[#ret + 1] = { Foreground = { Color = arrow_fg } }
        ret[#ret + 1] = { Background = { Color = arrow_bg } }
        ret[#ret + 1] = { Text = arrow }

        return ret
    end)
end

return M
