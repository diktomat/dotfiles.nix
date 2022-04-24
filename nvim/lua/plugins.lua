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

	use { 'numToStr/Comment.nvim',
		config = function() require('Comment').setup() end
	}

	use { 'ellisonleao/gruvbox.nvim',
		requires = 'rktjmp/lush.nvim',
		config = function() vim.cmd('colorscheme gruvbox') end
	}

	use { 'neovim/nvim-lspconfig',
		config = function()
			local on_attach = function(_, bufnr)
				vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
			end

			require('lspconfig').gopls.setup {
				on_attach = on_attach,
			}

			-- Lua for Neovim
			local runtime_path = vim.split(package.path, ';')
			table.insert(runtime_path, 'lua/?.lua')
			table.insert(runtime_path, 'lua/?/init.lua')
			require('lspconfig').sumneko_lua.setup {
				on_attach = on_attach,
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

