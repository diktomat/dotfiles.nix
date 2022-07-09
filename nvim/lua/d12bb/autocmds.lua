vim.api.nvim_create_augroup("d12bb", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = "d12bb",
	pattern = "/,?",
	desc = "Highlight only when searching",
	callback = function()
		vim.opt.hlsearch = true
	end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = "d12bb",
	pattern = "/,?",
	desc = "Highlight only when searching",
	callback = function()
		vim.opt.hlsearch = false
	end,
})

-- for some reason TermEnter doesnt work, so BufEnter term://*
vim.api.nvim_create_autocmd({ "BufEnter", "TermOpen" }, {
	group = "d12bb",
	pattern = "term://*",
	desc = "Insert only for terminals",
	command = "startinsert",
})

vim.api.nvim_create_autocmd("FileType", {
	group = "d12bb",
	pattern = "*",
	desc = "Notify when Treesitter parser is not installed",
	callback = function()
		local parsers = require("nvim-treesitter.parsers")
		local lang = parsers.get_buf_lang()
		if lang ~= "help" and parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) then
			vim.notify("TS parser can be installed with :TSInstall " .. lang)
		end
	end,
})
