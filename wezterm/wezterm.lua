local wezterm = require 'wezterm'

local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

local function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

config.unix_domains = {
    {
        name = 'unix',
    },
}
config.default_gui_startup_args = { 'connect', 'unix' }

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab('CurrentPaneDomain')
    },
    {
        key = 'f',
        mods = 'LEADER',
        action = wezterm.action_callback(function(window, pane)
            local success, stdout, stderr = wezterm.run_child_process {
                'bash', '-c', 'find -L ~/projects ~ -mindepth 1 -maxdepth 2 -type d',
            }

            if not success then
                -- it logs invalid find entries when empty, need to do smth about that
                --wezterm.log_error(stderr)
            end

            local choices = {}

            for _, name in ipairs(mux.get_workspace_names()) do
                table.insert(choices, { id = name, label = name })
            end

            for _, line in ipairs(wezterm.split_by_newlines(stdout)) do
                local parts = {}
                string.gsub(line, string.format("([^%s]+)", '/'), function(c) parts[#parts + 1] = c end)
                local last_part = parts[#parts]
                if last_part ~= nil then
                    table.insert(choices, { id = last_part, label = line })
                end
            end

            window:perform_action(
                act.InputSelector {
                    action = wezterm.action_callback(function(_, _, id, label)
                        if id == nil then
                            wezterm.log_info('Cancelled')
                            return
                        end

                        if has_value(mux.get_workspace_names(), id) then
                            wezterm.mux.set_active_workspace(id)
                            return
                        end

                        local main_screen = wezterm.gui.screens().main
                        local _, new_pane, new_window = mux.spawn_window({
                            workspace = id,
                            cwd = label,
                            width = main_screen.width,
                            height = main_screen.height
                        })
                        wezterm.mux.set_active_workspace(id)

                        new_pane:send_text('nvim .\r\n')

                        local gui_window = new_window:gui_window()
                        gui_window:perform_action(act.SpawnTab('CurrentPaneDomain'), new_pane)
                        gui_window:perform_action(act.SpawnTab('CurrentPaneDomain'), new_pane)
                        gui_window:perform_action(act.ActivateTab(1), new_pane)
                    end
                    ),
                    title = '',
                    choices = choices,
                    fuzzy = true,
                },
                pane
            )
        end)
    },
}

for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = act.ActivateTab(i - 1)
    })
end

wezterm.on("update-right-status", function(window, _)
    window:set_right_status(window:active_workspace())
end)

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
    local pane = mux.get_pane(tab.active_pane.pane_id)
    wezterm.log_info(pane:get_title(), pane)
    local format = " [%s] %s"
    if pane:has_unseen_output() then
        format = format .. "*"
    end
    format = format .. " "
    return {
        { Text = string.format(format, tab.tab_index + 1, pane:get_title()) }
    }
end)

config.window_background_opacity = 1.0

local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'rose-pine'
    else
        return 'rose-pine-dawn'
    end
end


config.color_scheme = scheme_for_appearance('Dark')
config.font_size = 14

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.colors = {
    tab_bar = {
        background = '#26233a',
        active_tab = {
            bg_color = '#6e6a86',
            fg_color = '#e0def4',
        },
        inactive_tab = {
            bg_color = '#26233a',
            fg_color = '#e0def4',
        },
        inactive_tab_hover = {
            bg_color = '#403d52',
            fg_color = '#e0def4',
        },
        new_tab = {
            bg_color = '#21202e',
            fg_color = '#e0def4',
        },
        new_tab_hover = {
            bg_color = '#403d52',
            fg_color = '#e0def4',
        },
    }
}

return config
