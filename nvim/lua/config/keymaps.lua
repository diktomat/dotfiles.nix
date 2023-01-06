M = {}
local tsb = require("telescope.builtin")

M.general = function()
	vim.keymap.set(
		"t",
		"<esc><esc>",
		vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true),
		{ desc = "Escape Terminal" }
	)

	require("which-key").register({
		["["] = {
			name = "Previous..",
			c = { "<cmd>cprev<cr>", ":cprev" },
			l = { "<cmd>lprev<cr>", ":lprev" },
			b = { "<cmd>bprev<cr>", ":bprev" },
			t = {
				function()
					require("todo-comments").jump_prev()
				end,
				"Prev Todo",
			},
		},
		["]"] = {
			name = "Next..",
			c = { "<cmd>cnext<cr>", ":cnext" },
			l = { "<cmd>lnext<cr>", ":lnext" },
			b = { "<cmd>bnext<cr>", ":bnext" },
			t = {
				function()
					require("todo-comments").jump_next()
				end,
				"Next Todo",
			},
		},
		["<leader>"] = {
			name = "Space mode",
			F = { tsb.find_files, "File Picker (All)" },
			b = { tsb.buffers, "Buffer Picker" },
			f = { tsb.git_files, "File Picker" },
			g = {
				function()
					require("FTerm").scratch({ cmd = "lazygit" })
				end,
				"LazyGit",
			},
			gq = { vim.lsp.buf.format, "Format Buffer" },
			h = {
				name = "+help",
				c = { tsb.commands, "Command Palette" },
				h = { tsb.help_tags, "Vim Help" },
				m = { tsb.man_pages, "Man Pages" },
			},
			j = { tsb.jumplist, "Jumplist Picker" },
			R = { tsb.oldfiles, "Recent Files" },
			s = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
			t = {
				function()
					require("FTerm").toggle()
				end,
				"Toggle Terminal",
			},
			u = { "<cmd>UndotreeToggle<cr>", "Undo Tree" },
			w = {
				name = "+window",
				w = { "<cmd>WindowsMaximize<cr>", "Maximize Window" },
				["="] = { "<cmd>Windows Equalize<cr>", "Equalize Windows" },
				a = { "<cmd>WindowsToggleAutowidth<cr>", "Toggle Autowidth" },
			},
			xd = { "<cmd>TroubleToggle document_diagnostics<cr>", "Trouble Diagnostics" },
			xl = { "<cmd>TroubleToggle loclist<cr>", "Trouble LL" },
			xq = { "<cmd>TroubleToggle quickfix<cr>", "Trouble QF" },
			xt = { "<cmd>TodoTrouble<cr>", "Trouble Todos" },
			xw = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble Diagnostics (All)" },
			xx = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
			["'"] = { tsb.resume, "Resume last picker" },
			["/"] = { tsb.live_grep, "Live Grep" },
		},
		g = {
			name = "Goto mode",
			h = { "0", "Line Start" },
			s = { "^", "First Non-blank" },
			["."] = { "`.", "Last Modification" },
		},
	})
end

M.lsp = function()
	require("which-key").register({
		["["] = {
			d = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
		},
		["]"] = {
			d = { vim.diagnostic.goto_next, "Next Diagnostic" },
		},
		["<leader>"] = {
			a = { vim.lsp.buf.code_action, "Code Action" },
			d = {
				function()
					tsb.diagnostics({ bufnr = 0 })
				end,
				"Diagnostics Picker",
			},
			D = { tsb.diagnostics, "Diagnostic Picker (All)" },
			e = { vim.diagnostic.open_float, "Explain Diagnostic" },
			k = { vim.lsp.buf.hover, "Hover Info" },
			r = { vim.lsp.buf.rename, "Rename" },
			S = { tsb.lsp_document_symbols, "Symbol Picker" },
			w = { tsb.lsp_workspace_symbols, "Symbol Picker (All)" },
		},
		g = {
			d = { vim.lsp.buf.definition, "Definition" },
			D = { vim.lsp.buf.type_definition, "Type Definition" },
			i = { vim.lsp.buf.implementation, "Implementation" },
			r = { vim.lsp.buf.references, "References" },
		},
	}, { buffer = 0 })
end

return M
