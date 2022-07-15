local wk = require("which-key")
local tsb = require("telescope.builtin")

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_attach = function(client, buf)
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

	vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")

	-- Stylua for Lua, LSP no good here..
	if client.name ~= "sumneko_lua" and client.resolved_capabilities.document_formatting then
		wk.register({ ["<leader>gq"] = { vim.lsp.buf.format, "Format File" } }, { buffer = buf })
		vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")

		vim.api.nvim_create_augroup("autoformat", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = "autoformat",
			buffer = buf,
			desc = "Autoformat on save",
			callback = vim.lsp.buf.format,
		})
	end
end

require("go").setup({
	dap_debug = false,
	disable_per_project_cfg = true,
	lsp_cfg = { capabilities = capabilities },
	lsp_format_on_save = false, -- autoformat already setup in lsp_attach
	lsp_gofumpt = true,
	lsp_keymaps = false, -- keymaps already setup in lsp_attach
	lsp_on_client_start = lsp_attach,
	textobjects = false, -- have my on setup in treesitter.lua
	verbose_tests = false,
})

require("rust-tools").setup({ -- {{{3
	server = {
		capabilities = capabilities,
		on_attach = function(client, buf)
			vim.api.nvim_create_augroup("codelens", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				group = "codelens",
				buffer = buf,
				desc = "Refresh Codelens",
				callback = function()
					vim.lsp.codelens.refresh()
				end,
			})
			wk.register({
				["<leader>cl"] = { vim.lsp.codelens.run, "Run Codelens" },
				["<leader>cr"] = { require("rust-tools.runnables").runnables, "Rust Runnables" },
			})
			vim.cmd("highlight link LspCodeLens Comment")
			vim.cmd("highlight link LspCodeLensSeparator Comment")

			lsp_attach(client, buf)
		end,
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
