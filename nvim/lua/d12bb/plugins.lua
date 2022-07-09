-- stylua: ignore
require("packer").startup({{
	{ "wbthomason/packer.nvim" },

	{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-cmdline" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "hrsh7th/cmp-path" },
	{ "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
	{ "gpanders/editorconfig.nvim" },
	{ "j-hui/fidget.nvim", config = function() require("fidget").setup() end },
	{ "ray-x/go.nvim" },
	{ "luisiacc/gruvbox-baby" },
	{ "neovim/nvim-lspconfig" },
	{ "onsails/lspkind.nvim" },
	{ "nvim-lualine/lualine.nvim", requires = "kyazdani42/nvim-web-devicons" },
	{ "L3MON4D3/LuaSnip" },
		{ "saadparwaiz1/cmp_luasnip" },
	{ "simrat39/rust-tools.nvim" },
	{ "nvim-telescope/telescope.nvim", requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim" } },
		{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "folke/which-key.nvim", config = function() require("which-key").setup() end },
}, config = {
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end
	},
}})
