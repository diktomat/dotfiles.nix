vim.keymap.set('n', '<leader>p', ':Glow<cr>')
if vim.fn.findfile("Makefile") == "" then
	vim.cmd ':compiler pandoc'
end

