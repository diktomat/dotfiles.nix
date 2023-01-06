return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				integrations = {
					gitsigns = true,
					mini = true,
					native_lsp = { enabled = true },
					notify = true,
					treesitter = true,
					ts_rainbow = true,
					symbols_outline = true,
					telescope = true,
					lsp_trouble = true,
					which_key = true,
					fidget = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	-- {
	-- 	"luisiacc/gruvbox-baby",
	-- 	config = function()
	-- 		vim.g.gruvbox_baby_background_color = "dark"
	-- 		vim.g.gruvbox_baby_telescope_theme = 1
	-- 		vim.cmd.colorscheme("gruvbox-baby")
	-- 	end,
	-- },
	{
		"nvim-lualine/lualine.nvim",
		config = {
			options = {
				theme = "catppuccin",
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
					},
				},
			},
		},
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
