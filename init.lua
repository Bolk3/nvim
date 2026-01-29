local config_markdown = require('config.markdown')
require("config.lazy")
require("lsp")

vim.keymap.set("n", "<C-P>", ":Neotree <CR>")
vim.cmd("set noexpandtab")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=0")
vim.cmd("set softtabstop=0")
vim.cmd("set smarttab")

vim.cmd("set relativenumber")

vim.ui.select = require('dropbar.utils.menu').select

-- colorcolumn autocmd
vim.api.nvim_create_augroup("ColorColumnByFiletype", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "ColorColumnByFiletype",
  pattern = {"c", "cpp", 'sh'},
  callback = function()
    vim.opt_local.colorcolumn = "80"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = "ColorColumnByFiletype",
  pattern = {"lua",},
  callback = function()
    vim.opt_local.colorcolumn = "100"
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = 'ColorColumnByFiletype',
  pattern = { 'python' , 'java', 'javascript', 'javscriptreact', 'typescript', 'typescriptreact' },
  callback = function()
    vim.opt_local.colorcolumn = '120'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'java',
	callback = function(args)
		require 'jdtls.jdtls_setup'.setup()
	end
})

require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
	latex = config_markdown.latex,
})


