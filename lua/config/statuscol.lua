local builtin = require("statuscol.builtin")

require("statuscol").setup({
  segments = {
    -- Segment Diagnostics + DAP
    {
      sign = { name = { "Diagnostic.*", "Dap.*" }, maxwidth = 1, auto = false },
      click = "v:lua.ScSa",
    },
    -- Segment Git (Customisé via gitsigns)
    {
      sign = { name = { "GitSigns.*" }, maxwidth = 1, colwidth = 1, auto = false },
      click = "v:lua.ScSa",
    },
    -- Segment Numéros
    {
      text = { builtin.lnumfunc, " " },
      click = "v:lua.ScLa",
      condition = { true, builtin.not_empty }, -- N'affiche l'espace que si la ligne n'est pas vide
    },
    -- Segment Folds avec tes icônes custom
    {
      text = { builtin.foldfunc, " " },
      click = "v:lua.ScFa",
    },
  },
})

-- Diagnostics (Erreurs, Warnings...)
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- DAP (Debugger GDB)
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "󰁕", texthl = "DapStopped", linehl = "Visual", numhl = "" })

-- GitSigns (Généralement configuré dans son propre plugin)
require('gitsigns').setup({
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '󰍵' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
})

vim.opt.fillchars = {
  fold = " ",          -- Caractère de remplissage
  foldopen = "",      -- Icône quand c'est ouvert
  foldsep = " ",       -- Séparateur
  foldclose = "",     -- Icône quand c'est fermé
}

vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370" })          -- Couleur des numéros grisés
vim.api.nvim_set_hl(0, "LineNrCursor", { fg = "#e5c07b", bold = true }) -- Ligne actuelle en jaune/gras
