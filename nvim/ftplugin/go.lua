-- vim.bo.makeprg = "go build 2>&1"
-- vim.bo.errorformat = "%f:%l:%c: %m,%-G#%s"
vim.api.nvim_command("compiler go")

vim.api.nvim_create_autocmd("BufWritePre", {
	group = "d12bb",
	pattern = "*.go",
	desc = "Format on save",
	callback = vim.lsp.buf.formatting_sync,
})
