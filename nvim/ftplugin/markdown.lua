-- Open Markdown preview (via glow) in floating window, exit with <esc>
local preview = function()
	local path   = vim.fn.shellescape(vim.fn.expand('%'))
	local pbuf   = vim.api.nvim_create_buf(false, true)
	local height = vim.api.nvim_list_uis()[1].height
	local width  = vim.api.nvim_list_uis()[1].width

	vim.api.nvim_open_win(pbuf, true, {
		relative = 'editor',
		width    = math.floor(width * 0.8),
		height   = math.floor(height * 0.8),
		row      = (height/2) - (height*0.4),
		col      = (width/2) - (width*0.4),
		style    = 'minimal',
		border   = 'rounded',
	})
	vim.api.nvim_buf_set_keymap(pbuf, 'n', '<esc>', ':q<cr>', {})
	vim.fn.termopen('glow '..path)
end
require('which-key').register {['<leader>p'] = { preview, 'Preview Markdown' }}
-- vim.keymap.set('n', '<leader>p', preview, { desc = 'Preview Markdown' })
--   as soon as WhichKey implements desc

if vim.fn.findfile("Makefile") == "" then
	vim.cmd ':compiler pandoc'
end

