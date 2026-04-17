require("config.dap.python")
require("config.dap.gdb")
require("config.dap.java")

require("dap-view").setup({
    winbar = {
        sections = { "disassembly", "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
        default_section = "watches",
        controls = {
            enabled = true,
            buttons = { "play", "step_into", "step_over", "step_out", "step_back", "run_last", "term_restart", "terminate", "disconnect" },
            custom_buttons = {
                term_restart = {
                    render = function(session)
                        local group = session and "ControlTerminate" or "ControlRunLast"
                        local icon = session and "" or ""
                        return "%#NvimDapView" .. group .. "#" .. icon .. "%*"
                    end,
                    action = function(clicks, button, modifiers)
                        local dap = require("dap")
                        local alt = clicks > 1 or button ~= "l" or modifiers:gsub(" ", "") ~= ""
                        if not dap.session() then
                            dap.run_last()
                        elseif alt then
                            dap.disconnect()
                        else
                            dap.terminate()
                        end
                    end,
                },
            },
        },
    },
    windows = {
        size = 0.25,
        position = "below",
    },
})
