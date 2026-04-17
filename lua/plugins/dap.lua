return {
    "mfussenegger/nvim-dap",
    "theHamsta/nvim-dap-virtual-text",
    {
        "igorlfs/nvim-dap-view",
        -- let the plugin lazy load itself
        lazy = false,
        version = "1.*",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
    },
    {
        url = "https://codeberg.org/Jorenar/nvim-dap-disasm.git",
        dependencies = "igorlfs/nvim-dap-view",
        config = true,
    },
}
