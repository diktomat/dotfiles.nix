local open_float_win = function()
	local pbuf = vim.api.nvim_create_buf(false, true)
	local height = vim.api.nvim_list_uis()[1].height
	local width = vim.api.nvim_list_uis()[1].width

	vim.api.nvim_open_win(pbuf, true, {
		relative = "editor",
		width = math.floor(width * 0.8),
		height = math.floor(height * 0.8),
		row = (height / 2) - (height * 0.4),
		col = (width / 2) - (width * 0.4),
		style = "minimal",
		border = "rounded",
	})

	return pbuf
end

local lazygit = function()
	local gitdir = vim.fn.finddir(".git", ";")
	open_float_win()
	vim.fn.termopen("lazygit -p " .. gitdir, {
		on_exit = function()
			vim.cmd("q")
		end,
	})
	vim.cmd("startinsert")
end

return {
	open_float_win = open_float_win,
	lazygit = lazygit,
}
