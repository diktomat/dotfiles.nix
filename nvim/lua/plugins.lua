-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim' -- let packer manage itself
	use 'gpanders/editorconfig.nvim'

	use { 'ellisonleao/gruvbox.nvim',
		requires = 'rktjmp/lush.nvim',
		config = function() vim.cmd('colorscheme gruvbox') end
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

	use { 'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim',
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

