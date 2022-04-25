vim.o.shell = "/usr/bin/env fish"
vim.opt.colorcolumn = "101"
vim.opt.cursorline = true
vim.opt.expandtab = false
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.guifont = "FiraCode Nerd Font Mono"
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.list = true -- show tab chars
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.shelltemp = false -- use pipe instead of tmp file for shell commands
vim.opt.shiftwidth = 4
vim.opt.smartcase = true
vim.opt.spell = true
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/myspell.utf-8.add"
vim.opt.spelllang = "de_20,en_us"
vim.opt.spelloptions = "camel"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.wildmode = "longest:full,full"

require("plugins")
require("keymaps")
