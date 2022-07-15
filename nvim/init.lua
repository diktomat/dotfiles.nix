-- vim:set path+=./lua,$XDG_DATA_HOME/nvim/site/pack/packer/start/*/lua :
vim.g.mapleader = " "
vim.o.shell = "fish"
vim.opt.colorcolumn = "+1"
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.cursorline = true
vim.opt.expandtab = false
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.guifont = "FiraCode Nerd Font Mono"
vim.opt.hlsearch = false -- autotoggled when searching, see user.autocmds
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.linebreak = false
vim.opt.list = true
vim.opt.listchars = "tab:> ,lead:·,trail:·,extends:⇢,precedes:⇠,nbsp:+"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.shelltemp = false -- use pipe instead of tmp file for shell commands
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.textwidth = 100
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.wildmode = "longest:full,full"

-- :h ft_rust.txt
vim.g.rust_fold = 1
vim.g.rust_recommended_style = 0 -- would set expandtab otherwise

require("d12bb.plugins")
require("d12bb.misc")
require("d12bb.cmp")
require("d12bb.lsp")
require("d12bb.keymaps")
require("d12bb.autocmds")

vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_telescope_theme = 1
vim.cmd("colorscheme gruvbox-baby")
require("lualine").setup()

if vim.g.neovide then
	vim.g.neovide_remember_window_size = true
	-- cd to home when starting Neovide.app
	if vim.fn.getcwd() == "/" then
		vim.api.nvim_set_current_dir("~")
	end
end
