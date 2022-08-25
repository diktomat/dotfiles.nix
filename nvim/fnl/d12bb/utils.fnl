local M = {}

M.open_float_win = function()
	local pbuf = vim.api.nvim_create_buf(false, true)
	local height = vim.api.nvim_list_uis()[1].height
	local width = vim.api.nvim_list_uis()[1].width

	vim.api.nvim_open_win(pbuf, true, {
		relative = "editor",
		width = math.floor(width * 0.8),
		height = math.floor(height * 0.8),
		row = height * 0.1,
		col = width * 0.1,
		style = "minimal",
		border = "rounded",
	})

	return pbuf
end

M.lazygit = function()
	local gitroot = vim.fn.fnamemodify(vim.fn.finddir(".git", ";"), ":h") -- find .git/, use parent
	M.open_float_win()
	vim.fn.termopen("lazygit -p " .. gitroot, {
		on_exit = function()
			vim.cmd("q")
		end,
	})
	vim.cmd("startinsert")
end

return M
