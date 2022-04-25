if vim.g.lua_autoformat == nil then
	vim.g.lua_autoformat = true
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.lua",
		callback = function()
			vim.cmd("%!stylua --stdin-filepath % -")
		end,
	})
end
