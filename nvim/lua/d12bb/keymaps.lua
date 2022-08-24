local M = {}
local wk = require("which-key")
local tsb = require("telescope.builtin")

M.general = function()
	wk.register({
		["["] = {
			name = "Previous...",
			c = { "<cmd>cprev<cr>", ":cprev" },
			l = { "<cmd>lprev<cr>", ":lprev" },
		},
		["]"] = {
			name = "Next...",
			c = { "<cmd>cnext<cr>", ":cnext" },
			l = { "<cmd>lnext<cr>", ":lnext" },
		},
		["<leader>f"] = { tsb.find_files, "Find Files" },
		["<leader>F"] = {
			name = "Find (Telescope)",
			b = { tsb.buffers, "Buffers" },
			g = { tsb.live_grep, "Live Grep" },
			G = { tsb.grep_string, "Grep String" },
			h = { tsb.help_tags, "Vim Help" },
			H = { tsb.man_pages, "Man Pages" },
			d = { require("dash").search, "Dash" },
			q = { tsb.quickfix, "Quickfix List" },
			j = { tsb.jumplist, "Jumplist" },
		},
		["<leader>g"] = {
			name = "Open ...",
			g = { require("d12bb.utils").lazygit, "Lazygit" },
			t = { require("lspsaga.floaterm").open_float_terminal, "Terminal" },
		},
		["<leader>k"] = { "<cmd>DashWord<cr>", "Dash Word Under Cursor" },
	})

	local function t(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	wk.register({
		["<Esc><Esc>"] = { t([[<C-\><C-n>]]), "Escape Terminal" },
	}, { mode = "t" })

	local ls = require("luasnip")
	vim.keymap.set({ "i", "s" }, "<C-j>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })
	vim.keymap.set({ "i", "s" }, "<C-k>", function()
		if ls.jumpable(-1) then
			ls.jump(-1)
		end
	end, { silent = true })
	vim.keymap.set("i", "<C-l>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end)
end

M.lsp = function(buf)
	wk.register({
		["gd"] = { require("lspsaga.definition").preview_definition, "Preview Definition" },
		["gD"] = { vim.lsp.buf.definition, "Go to Definition" },
		["gh"] = { require("lspsaga.finder").lsp_finder, "Definition and References" },
		["K"] = { vim.lsp.buf.hover, "Hover Info" },
		["<leader>q"] = { vim.diagnostic.setqflist, "Diagnostics -> Quickfix" },
		["[d"] = { require("lspsaga.diagnostic").goto_prev, "Previous Diagnostic" },
		["]d"] = { require("lspsaga.diagnostic").goto_next, "Next Diagnostic" },
		["<leader>e"] = { require("lspsaga.diagnostic").show_line_diagnostics, "Explain Diagnostic" },
		["<leader>ca"] = { require("lspsaga.codeaction").code_action, "Code Action" },
		["<leader>R"] = { require("lspsaga.rename").lsp_rename, "Rename Symbol" },
		["<leader>r"] = { tsb.lsp_references, "References to Symbol" },
		["<leader>fs"] = { tsb.lsp_document_symbols, "Document Symbols" },
		["<leader>fS"] = { tsb.lsp_workspace_symbols, "Workspace Symbols" },
		["<leader>gq"] = { vim.lsp.buf.format, "Format File" },
		["<C-b>"] = {
			function()
				require("lspsaga.action").smart_scroll_with_saga(-1)
			end,
		},
		["<C-f>"] = {
			function()
				require("lspsaga.action").smart_scroll_with_saga(1)
			end,
		},
	}, {
		buffer = buf,
	})
end

return M
