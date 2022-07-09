local ts = require("telescope")

ts.setup({
	defaults = {
		layout_strategy = "flex",
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})
ts.load_extension("fzf")
