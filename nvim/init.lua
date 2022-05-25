-- vim:set path+=./lua,$XDG_DATA_HOME/nvim/site/pack/packer/start/*/lua fdm=marker fdl=1 :
-- Global settings {{{1
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
vim.g.mapleader = " "
vim.o.shell = "/usr/bin/env fish"
vim.opt.colorcolumn = "+1"
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.cursorline = true
vim.opt.expandtab = false
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.guifont = "FiraCode Nerd Font Mono"
vim.opt.hlsearch = false -- autotoggled when searching, see below
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

-- Autocmds {{{2
vim.api.nvim_create_augroup("d12bb", { clear = true })
vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = "d12bb",
	pattern = "/,?",
	desc = "Highlight only when searching",
	callback = function()
		vim.opt.hlsearch = true
	end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = "d12bb",
	pattern = "/,?",
	desc = "Highlight only when searching",
	callback = function()
		vim.opt.hlsearch = false
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = "d12bb",
	pattern = "*",
	desc = "Notify when Treesitter parser is not installed",
	callback = function()
		local parsers = require("nvim-treesitter.parsers")
		local lang = parsers.get_buf_lang()
		if lang ~= "help" and parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) then
			vim.notify("TS parser can be installed with :TSInstall " .. lang)
		end
	end,
})

-- Plugins {{{1
-- Packer {{{2
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
	{ "folke/which-key.nvim", config = function() require("which-key").setup() end },
}, config = {
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end
	},
}})
local cmp = require("cmp")
local wk = require("which-key")
local ts = require("telescope")
local tsb = require("telescope.builtin")

require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
})

-- CMP {{{2
cmp.setup({
	formatting = {
		format = require("lspkind").cmp_format({
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[lsp]",
				nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
			},
		}),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "path" },
	}, {
		{ name = "buffer", keyword_length = 3 },
	}),
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}, {
		{ name = "buffer", keyword_length = 3 },
	}),
})

-- LSP {{{2
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_attach = function(client, buf)
	wk.register({
		["gD"] = { vim.lsp.buf.declaration, "Go to Declaration" },
		["gd"] = { vim.lsp.buf.definition, "Go to Definition" },
		["K"] = { vim.lsp.buf.hover, "Hover Info" },
		["<leader>q"] = { vim.diagnostic.setloclist, "Diagnostics -> Loclist" },
		["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
		["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
		["<leader>e"] = { vim.diagnostic.open_float, "Explain Diagnostic" },
		["<leader>c"] = { vim.lsp.buf.code_action, "Code Action" },
		["<leader>R"] = { vim.lsp.buf.rename, "Rename Symbol" },
		["<leader>r"] = { tsb.lsp_references, "References to Symbol" },
		["<leader>fs"] = { tsb.lsp_document_symbols, "Document Symbols" },
		["<leader>fS"] = { tsb.lsp_workspace_symbols, "Workspace Symbols" },
	}, {
		buffer = buf,
	})

	vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")

	-- Stylua for Lua, LSP no good here..
	if client.name ~= "sumneko_lua" and client.resolved_capabilities.document_formatting then
		wk.register({ ["<leader>gq"] = { vim.lsp.buf.formatting_sync, "Format File" } }, { buffer = buf })
		vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
		vim.api.nvim_create_augroup("autoformat", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = "autoformat",
			buffer = buf,
			desc = "Autoformat on save",
			callback = vim.lsp.buf.formatting_sync,
		})
	end
end

require("lspconfig").gopls.setup({ -- {{{3
	capabilities = capabilities,
	on_attach = lsp_attach,
	settings = {
		gopls = {
			gofumpt = true,
		},
	},
})

require("rust-tools").setup({ -- {{{3
	server = {
		capabilities = capabilities,
		on_attach = lsp_attach,
	},
})

require("lspconfig").sumneko_lua.setup({ -- {{{3
	capabilities = capabilities,
	on_attach = lsp_attach,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Luasnip {{{2
local ls = require("luasnip")
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set("i", "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

-- Telescope {{{2
ts.setup({
	defaults = {
		layout_strategy = "flex",
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
ts.load_extension("fzf")

-- WhichKey {{{2
wk.register({
	["["] = { name = "Previous..." },
	["]"] = { name = "Next..." },
	["<leader>f"] = {
		name = "Find (Telescope)",
		b = { tsb.buffers, "Buffers" },
		f = { tsb.find_files, "Find Files" },
		g = { tsb.live_grep, "Live Grep" },
		G = { tsb.grep_string, "Grep String" },
		h = { tsb.help_tags, "Vim Help" },
		H = { tsb.man_pages, "Man Pages" },
		q = { tsb.quickfix, "Quickfix List" },
		j = { tsb.jumplist, "Jumplist" },
	},
})

-- Misc {{{1
vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_telescope_theme = 1
vim.cmd("colorscheme gruvbox-baby")
require("lualine").setup()

if vim.fn.exists("g:neovide") == 1 and vim.fn.getcwd() == "/" then
	vim.api.nvim_set_current_dir("~") -- cd to home when starting Neovide.app
end
