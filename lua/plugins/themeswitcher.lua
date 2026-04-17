return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 998,
    dependencies = {
      "oskarnurm/koda.nvim",
      "askfiy/visual_studio_code",
      "yonatanperel/lake-dweller.nvim",
      "serhez/teide.nvim",
      "folke/tokyonight.nvim",
      { "everviolet/nvim", name = "evergarden" },
      { "catppuccin/nvim", name = "catppuccin" },
    },
    config = function()
      require("themery").setup({
        livePreview = true,
        themes = {

          -- ── koda ────────────────────────────────────────────────
          { name = "Koda Moss",               colorscheme = "koda-moss" },
          {
            name = "Koda Moss (transparent)",
            colorscheme = "koda-moss",
            before = [[require("koda").setup({ transparent = true })]],
          },

          -- ── visual studio code ───────────────────────────────────
          { name = "VS Code",                 colorscheme = "visual_studio_code" },

          -- ── lake-dweller ─────────────────────────────────────────
          {
            name = "Lake Dweller",
            colorscheme = "lake-dweller",
            before = [[require("lake-dweller").setup({ variant = "lake-dweller" })]],
          },
          {
            name = "Pond Dweller",
            colorscheme = "lake-dweller",
            before = [[require("lake-dweller").setup({ variant = "pond-dweller" })]],
          },
          {
            name = "Ocean Dweller",
            colorscheme = "lake-dweller",
            before = [[require("lake-dweller").setup({ variant = "ocean-dweller" })]],
          },

          -- ── teide ────────────────────────────────────────────────
          { name = "Teide",                   colorscheme = "teide" },

          -- ── tokyonight ───────────────────────────────────────────
          { name = "Tokyo Night",             colorscheme = "tokyonight" },
          { name = "Tokyo Storm",             colorscheme = "tokyonight-storm" },
          { name = "Tokyo Moon",              colorscheme = "tokyonight-moon" },
          { name = "Tokyo Day",               colorscheme = "tokyonight-day" },

          -- ── catppuccin ───────────────────────────────────────────
          {
            name = "Catppuccin Latte",
            colorscheme = "catppuccin",
            before = [[require("catppuccin").setup({ flavour = "latte" })]],
          },
          {
            name = "Catppuccin Frappe",
            colorscheme = "catppuccin",
            before = [[require("catppuccin").setup({ flavour = "frappe" })]],
          },
          {
            name = "Catppuccin Macchiato",
            colorscheme = "catppuccin",
            before = [[require("catppuccin").setup({ flavour = "macchiato" })]],
          },
          {
            name = "Catppuccin Mocha",
            colorscheme = "catppuccin",
            before = [[require("catppuccin").setup({ flavour = "mocha" })]],
          },

          -- ── evergarden ───────────────────────────────────────────
          {
            name = "Evergarden Fall",
            colorscheme = "evergarden",
            before = [[
              require("evergarden").setup({
                theme = { variant = "fall", accent = "green" },
                editor = { transparent_background = false },
              })
            ]],
          },
          {
            name = "Evergarden Winter",
            colorscheme = "evergarden",
            before = [[
              require("evergarden").setup({
                theme = { variant = "winter", accent = "green" },
                editor = { transparent_background = false },
              })
            ]],
          },
          {
            name = "Evergarden Spring",
            colorscheme = "evergarden",
            before = [[
              require("evergarden").setup({
                theme = { variant = "spring", accent = "green" },
                editor = { transparent_background = false },
              })
            ]],
          },
          {
            name = "Evergarden Summer",
            colorscheme = "evergarden",
            before = [[
              require("evergarden").setup({
                theme = { variant = "summer", accent = "green" },
                editor = { transparent_background = false },
              })
            ]],
          },
        },
      })

      vim.keymap.set("n", "<leader>ft", "<cmd>Themery<cr>", { desc = "Theme picker" })
    end,
  },
}
