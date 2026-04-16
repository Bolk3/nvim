local multigrep = require("config.telescope.multigrep")

local telescope_builtin = require("telescope.builtin")

vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>mg', function() multigrep.setup() end, { desc = 'Telescope multi live grep'})

vim.keymap.set('n', '<leader>b', "<cmd>DapToggleBreakpoint<CR>", { desc = 'Set breakpoint' })
vim.keymap.set('n', '<leader>dt', "<cmd>DapViewToggle<CR>", { desc = 'Toggle dap view' })
vim.keymap.set('n', '<F5>', "<cmd>DapContinue<CR>", { desc = 'Dap continue' })
vim.keymap.set('n', '<F10>', "<cmd>DapStepOver<CR>")
vim.keymap.set('n', '<F11>', "<cmd>DapStepInto<CR>")
vim.keymap.set('n', '<F12>', "<cmd>DapStepOut<CR>")
