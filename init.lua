require("config.lazy")
require("lsp")

vim.keymap.set("n", "<C-P>", ":Neotree <CR>")
vim.cmd("set noexpandtab")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=0")
vim.cmd("set softtabstop=0")
vim.cmd("set smarttab")

vim.cmd("set relativenumber")
