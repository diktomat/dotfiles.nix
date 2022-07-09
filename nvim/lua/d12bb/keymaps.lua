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
	["<leader>g"] = {
		name = "Open ...",
		g = { require("d12bb.utils").lazygit, "Lazygit" },
		t = { require("lspsaga.floaterm").open_float_terminal, "Terminal" },
	},
})

local function t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end
wk.register({
	["<Esc><Esc>"] = { t([[<C-\><C-n>]]), "Escape Terminal" },
}, { mode = "t" })


local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set("i", "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)
