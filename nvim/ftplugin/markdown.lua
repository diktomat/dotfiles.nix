if vim.fn.findfile("Makefile") == "" then
	vim.api.nvim_command("compiler pandoc")
end
