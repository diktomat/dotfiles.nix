if vim.g.go_autocmd == nil then
	vim.g.go_autocmd = true
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.go",
		callback = function()
			vim.lsp.buf.formatting()
		end,
	})
end
