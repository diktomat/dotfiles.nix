return {
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				plugins = {
					spelling = {
						enabled = true,
					},
				},
			})
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.comment").setup {}
			require("mini.completion").setup({
				lsp_completion = {
					source_func = "omnifunc",
				}
			})
			require("mini.cursorword").setup {}
			require("mini.pairs").setup {}
		end
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"kyazdani42/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "flex",
				},
			})
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{ "gpanders/editorconfig.nvim", version = "*" },
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		config = function()
			vim.g.undotree_ShortIndicators = true
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("trouble").setup({
				use_diagnostic_signs = true,
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("todo-comments").setup()
		end,
	},
	{
		"saecki/crates.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("crates").setup({
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})
		end,
	},
	{
		"numToStr/FTerm.nvim",
	},
}
