local wk = require("which-key")
local tsb = require("telescope.builtin")

wk.register({
	["["] = {
		name = "Previous...",
		c = { "<cmd>cprev<cr>", ":cprev" },
		l = { "<cmd>lprev<cr>", ":lprev" },
	},
	["]"] = {
		name = "Next...",
		c = { "<cmd>cnext<cr>", ":cnext" },
		l = { "<cmd>lnext<cr>", ":lnext" },
	},
	["<leader>f"] = {
		name = "Find (Telescope)",
		b = { tsb.buffers, "Buffers" },
		f = { tsb.find_files, "Find Files" },
		g = { tsb.live_grep, "Live Grep" },
		G = { tsb.grep_string, "Grep String" },
		h = { tsb.help_tags, "Vim Help" },
		H = { tsb.man_pages, "Man Pages" },
		q = { tsb.quickfix, "Quickfix List" },
		j = { tsb.jumplist, "Jumplist" },
	},
	["<leader>g"] = { require("d12bb.utils").lazygit, "Lazygit" },
})

local function t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end
wk.register({
	["<Esc><Esc>"] = { t([[<C-\><C-n>]]), "Escape Terminal" },
}, { mode = "t" })
