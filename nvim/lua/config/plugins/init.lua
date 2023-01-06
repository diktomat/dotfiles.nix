return {
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
	{
		"folke/which-key.nvim",
		config = {
			plugins = {
				spelling = {
					enabled = true,
				},
			},
		},
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.comment").setup({})
			require("mini.completion").setup({
				lsp_completion = {
					source_func = "omnifunc",
				},
			})
			require("mini.cursorword").setup({})
			require("mini.pairs").setup({})
		end,
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
		config = true,
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
		config = {
			use_diagnostic_signs = true,
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = true,
	},
	{
		"saecki/crates.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = {
			null_ls = {
				enabled = true,
				name = "crates.nvim",
			},
		},
	},
	{
		"numToStr/FTerm.nvim",
	},
}
