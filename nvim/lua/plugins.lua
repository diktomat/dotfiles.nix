-- vim: set fdm=marker:

-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

require("packer").startup(function(use)
	use("wbthomason/packer.nvim") -- let packer manage itself
	use("gpanders/editorconfig.nvim")
	use("simrat39/symbols-outline.nvim")

	use({ -- {{{ Autopairs
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	}) -- }}}

	use({ -- {{{ Autocompletion/Snippets
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lua",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			require("luasnip.loaders.from_vscode").lazy_load()

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "path" },
					{ name = "buffer" },
				}),
				formatting = {
					format = lspkind.cmp_format(),
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable() then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<CR>"] = cmp.mapping({
						i = cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = false,
						}),
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm({
									behavior = cmp.ConfirmBehavior.Replace,
									select = false,
								})
							else
								fallback()
							end
						end,
					}),
				}),
			})
		end,
	}) -- }}}

	use({ -- {{{ Comment.nvim
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	}) -- }}}

	use({ -- {{{ Gruvbox
		"ellisonleao/gruvbox.nvim",
		requires = "rktjmp/lush.nvim",
		config = function()
			vim.cmd("colorscheme gruvbox")
		end,
	}) -- }}}

	use({ -- {{{ LSPConfig
		"neovim/nvim-lspconfig",
		requires = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

			require("lspconfig").gopls.setup({
				capabilities = capabilities,
				settings = {
					gopls = {
						gofumpt = true,
					},
				},
			})

			-- Lua for Neovim
			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")
			require("lspconfig").sumneko_lua.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = runtime_path,
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
	}) -- }}}

	use({ -- {{{ SpellSitter
		"lewis6991/spellsitter.nvim",
		config = function()
			require("spellsitter").setup()
		end,
	}) -- }}}

	use({ -- {{{ Telescope
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"nvim-telescope/telescope-file-browser.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "flex",
				},
				pickers = {
					lsp_code_actions = {
						theme = "cursor",
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			local exts = { "file_browser", "fzf" }
			for _, ext in pairs(exts) do
				require("telescope").load_extension(ext)
			end
		end,
	}) -- }}}

	use({ -- {{{ Treesitter
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			-- local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"comment",
					"css",
					"fish",
					"go",
					"help",
					"html",
					"javascript",
					"json",
					"lua",
					"make",
					"markdown",
					"python",
					"regex",
					"ruby",
					"rust",
					"scss",
					"swift",
					"toml",
					"typescript",
					"vim",
					"yaml",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	}) -- }}}

	use({ -- {{{ Which Key
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				plugins = {
					spelling = {
						enabled = true,
						suggestions = 30,
					},
				},
			})
		end,
	}) -- }}}
end)
