vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.lua",
	callback = function()
		vim.cmd("%!stylua --stdin-filepath % -")
	end,
})
