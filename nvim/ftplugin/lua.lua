local augroup = vim.api.nvim_create_augroup("Lua", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	buffer = 0,
	callback = function()
		vim.lsp.buf.format({
			filter = function(client)
				return client.name == "null-ls"
			end,
		})
	end,
})
