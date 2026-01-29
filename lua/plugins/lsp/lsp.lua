return {
	{ "neovim/nvim-lspconfig" },
	{
		'mason-org/mason-lspconfig.nvim',
		dependencies = {
			'mason-org/mason.nvim',
			'neovim/nvim-lspconfig'
		},
		config= function ()
			require("mason-lspconfig").setup({
				automatic_enable = {
					exclude = {
						'jdtls'
					}
				}
			})
		end
	},
	{ 'mfussenegger/nvim-jdtls' }
}
