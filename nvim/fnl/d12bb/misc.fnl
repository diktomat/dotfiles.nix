require("lspsaga").init_lsp_saga({
	code_action_lightbulb = {
		virtual_text = true,
	},
	symbol_in_winbar = {
		enable = true,
	},
})

local ts = require("telescope")
ts.setup({
	defaults = {
		layout_strategy = "flex",
	},
	extensions = {
		dash = {
			dash_app_path = "/Applications/Setapp/Dash.app",
		},
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})
ts.load_extension("fzf")

require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	textobjects = {
		select = {
			enable = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})
