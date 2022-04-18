-- Open Markdown preview (via glow) in floating window, exit with <esc>
-- TODO: make window nicer, not 100% width/height
local preview = function()
	local path = vim.fn.shellescape(vim.fn.expand('%'))
	local glowbuf = vim.api.nvim_create_buf(false, true)
	local glowwin = vim.api.nvim_open_win(glowbuf, true, {
		relative = 'editor',
		width    = 999,
		height   = 999,
		row      = 0,
		col      = 0,
	})
	vim.api.nvim_buf_set_keymap(glowbuf, 'n', '<esc>', ':q<cr>', {})
	vim.fn.termopen('glow '..path)
end
require('which-key').register {['<leader>p'] = { preview, 'Preview Markdown' }}

if vim.fn.findfile("Makefile") == "" then
	vim.cmd ':compiler pandoc'
end

