vim.api.nvim_buf_create_user_command(0, "Doc", "silent !cargo doc --open", {})
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("RustCodelens", {}),
	buffer = 0,
	desc = "Refresh Codelens",
	callback = vim.lsp.codelens.refresh,
})
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run Codelens" })
vim.keymap.set("n", "<leader>cr", function()
	require("rust-tools.runnables").runnables()
end, { desc = "Rust Runnables" })
