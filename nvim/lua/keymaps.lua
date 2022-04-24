vim.g.mapleader = " "

local telescope = require("telescope.builtin")

require("which-key").register({
	f = {
		name = "Find (Telescope)",
		b = { telescope.buffers, "Buffers" },
		f = { telescope.find_files, "Find Files" },
		g = { telescope.live_grep, "Live Grep" },
		h = { telescope.help_tags, "Vim Help" },
		m = { telescope.man_pages, "Man Pages" },
		q = { telescope.quickfix, "Quickfix list" },
		t = { telescope.tags, "cTags" },
	},
}, { prefix = "<leader>" })
