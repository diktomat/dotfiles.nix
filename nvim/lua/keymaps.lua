vim.g.mapleader = " "

local wk = require("which-key")

local telescope = require("telescope.builtin")
local telext = require("telescope").extensions
wk.register({
	f = {
		name = "Find (Telescope)",
		b = { telescope.buffers, "Buffers" },
		f = { telescope.find_files, "Find Files" },
		F = { telext.file_browser.file_browser, "File Browser" },
		g = { telescope.live_grep, "Live Grep" },
		G = { telescope.grep_string, "Grep" },
		h = { telescope.help_tags, "Vim Help" },
		m = { telescope.man_pages, "Man Pages" },
		d = { telext.dash.search, "Search Dash" },
		D = { "<cmd>DashWord<cr>", "Search Word in Dash" },
		q = { telescope.quickfix, "Quickfix list" },
		j = { telescope.jumplist, "Jumplist" },
		r = { telescope.lsp_references, "List References" },
		s = { telescope.lsp_document_symbols, "Document Symbols" },
		S = { telescope.lsp_workspace_symbols, "Workspace Symbols" },
	},
	lg = { require("utils").lazygit, "Open Lazygit" },
	s = { require("symbols-outline").toggle_outline, "Toggle Symbols Outline" },
}, { prefix = "<leader>" })

local lsbuf = vim.lsp.buf
local trouble = require("trouble")
wk.register({
	gd = { telescope.lsp_definitions, "Jump to Definition" },
	gtd = { telescope.lsp_type_definitions, "Jump to Definition of Type" },
	gD = { lsbuf.declaration, "Jump to Declaration" },
	gi = { telescope.lsp_implementations, "List Implementations" },
	gr = { function() trouble.toggle("lsp_references") end, "List References" },
	K = { lsbuf.hover, "Display Information" },
	["C-k"] = { lsbuf.signature_help, "Display Signature Help" },
	["<leader>c"] = {
		name = "Act on Code",
		c = { lsbuf.code_action, "Code Action" }, -- TODO: not in telescope anymore, use dressing.nvim or telescope-ui-select.nvim
		r = { lsbuf.rename, "Rename Symbol Everywhere" },
		f = { lsbuf.formatting, "Format File" },
	},
	["<leader>w"] = {
		name = "LSP Workspace",
		a = { lsbuf.add_workspace_folder, "Add Folder" },
		r = { lsbuf.remove_workspace_folder, "Remove Folder" },
		l = { function() vim.pretty_print(lsbuf.list_workspace_folders) end, "Workspace Folders" },
		s = { telescope.lsp_workspace_symbols, "Workspace Symbols" },
	},
	["<leader>x"] = {
		name = "Trouble",
		x = { trouble.toggle, "Toggle Trouble" },
		w = { function() trouble.toggle("workspace_diagnostics") end, "Workspace" },
		d = { function() trouble.toggle("document_diagnostics") end, "Document" },
		q = { function() trouble.toggle("quickfix") end, "Quickfix" },
		l = { function() trouble.toggle("loclist") end, "Loclist" },
		t = { function() trouble.toggle("todo") end, "TODO" },
	}
})
