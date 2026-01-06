return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = function ()
		require('catppuccin').setup({
			flavour = "auto",
			transparent_background = true,
			background = {
				light = "latte",
				dark = "mocha"
			}
		})
		vim.cmd.colorscheme "catppuccin"
	end
}
