vim.g.mapleader = " "
vim.opt.cmdheight = 0
vim.opt.colorcolumn = "+1"
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.cursorline = true
vim.opt.formatoptions = "jcroql"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.guifont = "FiraCode Nerd Font Mono"
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = "tab:| ,multispace:·   ,trail:·,extends:⇢,precedes:⇠,nbsp:+"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.shell = "fish"
-- vim.opt.shelltemp = false
vim.opt.shiftwidth = 0
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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("config.plugins", {
	lockfile = vim.fn.stdpath("config") .. "/.lazy-lock.json",
	checker = "enabled",
	defaults = {
		version = "*",
	}
})

vim.api.nvim_create_autocmd({ "BufEnter", "TermOpen" }, {
	desc = "Insert only for terminal buffers",
	group = vim.api.nvim_create_augroup("TermInsert", {}),
	pattern = "term://*",
	callback = "startinsert",
})

vim.cmd("hi link LspCodeLens Comment")
vim.cmd("hi link LspCodeLensSeparator Comment")

require("config.keymaps").general()

if vim.g.neovide == true then
	vim.g.neovide_remember_window_size = true
	if vim.fn.getcwd == "/" then
		vim.api.nvim_set_current_dir("~")
	end
end
