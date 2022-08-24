local wk = require("which-key")

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_attach = function(client, buf)
	vim.api.nvim_create_augroup("autoformat", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = "autoformat",
		buffer = buf,
		desc = "Autoformat on save",
		callback = function()
			vim.lsp.buf.format()
		end,
	})
	vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
	if client.name == "null-ls" then
		wk.register({ ["<leader>gq"] = { vim.lsp.buf.format, "Format File" } }, { buffer = buf })
		return
	end

	require("d12bb.keymaps").lsp(buf)
	vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

require("go").setup({
	dap_debug = false,
	disable_per_project_cfg = true,
	lsp_cfg = { capabilities = capabilities },
	lsp_diag_hdlr = false,
	lsp_format_on_save = false, -- autoformat already setup in lsp_attach
	lsp_gofumpt = true,
	lsp_keymaps = false, -- keymaps already setup in lsp_attach
	lsp_on_client_start = lsp_attach,
	textobjects = false, -- have my on setup in treesitter.lua
	verbose_tests = false,
})

local nlb = require("null-ls").builtins
require("null-ls").setup({
	sources = {
		nlb.formatting.stylua,
		nlb.formatting.swiftformat,
	},
	on_attach = lsp_attach,
})

require("rust-tools").setup({
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

require("lspconfig").sourcekit.setup({
	capabilities = capabilities,
	on_attach = lsp_attach,
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
