-- Open Markdown preview (via glow) in floating window, exit with <esc>
local preview = function()
	local path = vim.fn.shellescape(vim.fn.expand("%"))
	-- require("utils").open_float_win("glow " .. path, true)
	local wbuf = require("utils").open_float_win()
	vim.fn.termopen("glow " .. path)
	vim.api.nvim_buf_set_keymap(wbuf, "n", "<esc>", ":q<cr>", {})
end
require("which-key").register({ ["<leader>p"] = { preview, "Preview Markdown" } })
-- vim.keymap.set('n', '<leader>p', preview, { desc = 'Preview Markdown' })
--   as soon as WhichKey implements desc

if vim.fn.findfile("Makefile") == "" then
	vim.cmd(":compiler pandoc")
end
