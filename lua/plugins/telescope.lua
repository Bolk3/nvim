return {
	'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = function()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
	end
}
