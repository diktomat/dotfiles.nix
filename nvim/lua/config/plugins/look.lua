return {
	{
		"luisiacc/gruvbox-baby",
		config = function()
			vim.g.gruvbox_baby_background_color = "dark"
			vim.g.gruvbox_baby_telescope_theme = 1
			vim.cmd.colorscheme("gruvbox-baby")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "gruvbox-baby",
				},
				extensions = {
					"man",
					"quickfix",
					"symbols-outline",
				},
				sections = {
					lualine_c = {
						"filename",
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = { fg = "#ff9e64" },
						}
					}
				}
			})
		end,
	},
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		config = function()
			vim.o.winwidth = 10
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("windows").setup()
		end,
	},
}
