-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim' -- let packer manage itself
	use 'gpanders/editorconfig.nvim'

	use { 'windwp/nvim-autopairs',
		config = function() require('nvim-autopairs').setup() end
	}

	use { 'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp-signature-help', 'hrsh7th/cmp-nvim-lua',
			'SirVer/ultisnips', 'quangnguyen30192/cmp-nvim-ultisnips', 'honza/vim-snippets',
			'onsails/lspkind.nvim'
		},
		config = function()
			local cmp = require('cmp')
			local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')
			local lspkind = require('lspkind')

			cmp.setup {
				snippet = {
					expand = function(args)
						vim.fn["UltiSnips#Anon"](args.body)
					end,
				},
				sources = cmp.config.sources {
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lua' },
					{ name = 'ultisnips' },
					{ name = 'nvim_lsp_signature_help' },
					{ name = 'path' },
					{ name = 'buffer' },
				},
				formatting = {
					format = lspkind.cmp_format(),
				},
				mapping = cmp.mapping.preset.insert {
					['<Tab>'] = cmp.mapping(function(fallback)
						cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						cmp_ultisnips_mappings.jump_backwards(fallback)
					end, { 'i' , 's' }),
					['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
					['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
					['<CR>'] = cmp.mapping({
						i = cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Replace, select = false
						}),
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm({
									behavior = cmp.ConfirmBehavior.Replace, select = false
								})
							else
								fallback()
							end
						end
					}),
				},
			}
		end,
	}

	use { 'numToStr/Comment.nvim',
		config = function() require('Comment').setup() end
	}

	use { 'ellisonleao/gruvbox.nvim',
		requires = 'rktjmp/lush.nvim',
		config = function() vim.cmd('colorscheme gruvbox') end
	}

	use { 'neovim/nvim-lspconfig',
		requires = { 'hrsh7th/cmp-nvim-lsp', },
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

			require('lspconfig').gopls.setup {
				capabilities = capabilities,
			}

			-- Lua for Neovim
			local runtime_path = vim.split(package.path, ';')
			table.insert(runtime_path, 'lua/?.lua')
			table.insert(runtime_path, 'lua/?/init.lua')
			require('lspconfig').sumneko_lua.setup {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = 'LuaJIT',
							path    = runtime_path,
						},
						diagnostics = {
							globals = { 'vim', },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file('', true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}
		end,
	}

	use { 'lewis6991/spellsitter.nvim',
		config = function() require('spellsitter').setup() end,
	}

	use { 'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
	}

	use { 'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			-- local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
			require('nvim-treesitter.configs').setup {
				ensure_installed = { 'bash', 'c', 'comment', 'css', 'fish', 'go', 'help',
					'html', 'javascript', 'json', 'lua', 'make', 'markdown', 'python',
					'regex', 'ruby', 'rust', 'scss', 'swift', 'toml', 'typescript', 'vim',
					'yaml', },
				highlight = { enable = true, },
				indent    = { enable = true, },
			}
		end
	}

	use { 'folke/which-key.nvim',
		config = function()
			require('which-key').setup {
				plugins = {
					spelling = {
						enabled = true,
						suggestions = 30,
					},
				},
			}
		end
	}
end)

