return {
	{
		"luisiacc/gruvbox-baby",
		version = "*",
		config = function()
			vim.g.gruvbox_baby_background_color = "dark"
			vim.g.gruvbox_baby_telescope_theme = 1
			vim.cmd.colorscheme("gruvbox-baby")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		version = "*",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
			{ url = "https://git.sr.ht/~p00f/nvim-ts-rainbow", version = "*" },
			{ "RRethy/vim-illuminate", version = "*" },
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn", -- set to `false` to disable one of the mappings
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]a"] = "@parameter.outer",
							["]o"] = "@comment.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
							["]A"] = "@parameter.outer",
							["]O"] = "@comment.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[a"] = "@parameter.outer",
							["[o"] = "@comment.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
							["[A"] = "@parameter.outer",
							["[O"] = "@comment.outer",
						},
					},
				},
				rainbow = {
					enable = true,
					extended_mode = true,
				},
			})

			require("treesitter-context").setup()
			require("illuminate").configure()
			vim.api.nvim_create_autocmd("FileType", {
				desc = "Notify to install TS parsers",
				group = vim.api.nvim_create_augroup("TSnotify", {}),
				callback = function ()
					local parsers = require("nvim-treesitter.parsers")
					local lang = parsers.get_buf_lang()
					if !parsers.has_parser(lang) and parsers.get_parser_configs()[lang] then
						vim.notify("TS parser can be installed with :TSInstall "..lang)
					end
				end
			})
		end,
	},
	{
		"folke/which-key.nvim",
		version = "*",
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
		"nvim-lualine/lualine.nvim",
		version = "*",
		config = function()
			require("lualine").setup({
				options = {
					theme = "gruvbox-baby",
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		version = "*",
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim", version = "*" },
			{ "neovim/nvim-lspconfig", version = "*" },
			{ "folke/neodev.nvim", version = "*" },
			{ "simrat39/rust-tools.nvim", version = "*" },
			{ "jayp0521/mason-null-ls.nvim", version = "*" },
			{ "jose-elias-alvarez/null-ls.nvim", version = "*" },
			{
				"j-hui/fidget.nvim",
				version = "*",
				config = function()
					require("fidget").setup()
				end,
			},
		},
		config = function()
			local on_attach = function(client, buf)
				if client.name ~= "null-ls" then
					vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
					vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
				end
				-- require("config.lsp")
				require("config.keymaps").lsp()
			end
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason").setup()
			require("neodev").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "rust_analyzer", "sumneko_lua" },
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
				["sumneko_lua"] = function()
					require("lspconfig").sumneko_lua.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								telemetry = {
									enable = false,
								},
							},
						},
					})
				end,
				["rust_analyzer"] = function()
					require("rust-tools").setup({
						server = {
							on_attach = on_attach,
							capabilities = capabilities,
						},
						executor = require("rust-tools.executors").quickfix,
					})
				end,
			})

			require("mason-null-ls").setup({
				ensure_installed = { "stylua" },
				automatic_setup = true,
			})
			require("null-ls").setup()
			require("mason-null-ls").setup_handlers()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		version = "*",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp", version = "*" },
			{ "onsails/lspkind.nvim", version = "*" },
			{ "hrsh7th/cmp-buffer", version = "*" },
			{ "saadparwaiz1/cmp_luasnip", version = "*" },
			{ "L3MON4D3/LuaSnip", version = "*" },
			{ "rafamadriz/friendly-snippets", version = "*" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help", version = "*" },
			{ "saecki/crates.nvim" },
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				formatting = {
					format = require("lspkind").cmp_format(),
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-b>"] = cmp.mapping.scroll_docs(-8),
					["<C-f>"] = cmp.mapping.scroll_docs(8),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "crates" },
				}, {
					{ name = "buffer" , keyword_length = 3 },
				}),
			})
			cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"numToStr/Comment.nvim",
		version = "*",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		version = "*",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", version = "*", build = "make" },
			{ "kyazdani42/nvim-web-devicons", version = "*" },
			{ "nvim-lua/plenary.nvim", version = "*" },
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
		version = "*",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{ "gpanders/editorconfig.nvim", version = "*" },
	{
		"mbbill/undotree",
		version = "*",
		cmd = "UndotreeToggle",
		config = function()
			vim.g.undotree_ShortIndicators = true
		end,
	},
	{
		"folke/trouble.nvim",
		version = "*",
		cmd = { "TroubleToggle", "Trouble" },
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
		"simrat39/symbols-outline.nvim",
		version = "*",
		config = function()
			require("symbols-outline").setup()
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
	{
		"saecki/crates.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
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
		version = "*",
	},
}
