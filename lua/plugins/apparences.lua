return {
    {
        'mcauley-penney/visual-whitespace.nvim',
        event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                "rcarriga/nvim-notify",
                opts = {
                    background_colour = "#000000",
                },
            },
        },
    },
    {'itmammoth/doorboy.vim'}
}
