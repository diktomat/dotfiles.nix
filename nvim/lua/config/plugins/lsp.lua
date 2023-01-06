return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"folke/neodev.nvim",
		"simrat39/rust-tools.nvim",
		"jose-elias-alvarez/null-ls.nvim",
		"simrat39/symbols-outline.nvim",
		{
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup()
			end,
		},
	},
	config = function()
		local on_attach = function(client, buf)
			if client.name ~= "null-ls" then
				vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
				vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
			end
			-- require("config.lsp")
			require("config.keymaps").lsp()
		end
		require("neodev").setup()
		require("lspconfig")["sumneko_lua"].setup({
			on_attach = on_attach,
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
		require("rust-tools").setup({
			server = {
				on_attach = on_attach,
			},
			executor = require("rust-tools.executors").quickfix,
		})

		require("null-ls").setup({
			sources = {
				require("null-ls").builtins.formatting.stylua,
			}
		})
		require("symbols-outline").setup()
	end,
}
