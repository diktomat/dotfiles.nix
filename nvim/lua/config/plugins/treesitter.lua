return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
		{ url = "https://git.sr.ht/~p00f/nvim-ts-rainbow" },
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn", -- set to `false` to disable one of the mappings
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
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
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.outer",
						["]o"] = "@comment.outer",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.outer",
						["]O"] = "@comment.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.outer",
						["[o"] = "@comment.outer",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.outer",
						["[O"] = "@comment.outer",
					},
				},
			},
			rainbow = {
				enable = true,
				extended_mode = true,
			},
		})

		require("treesitter-context").setup()
		vim.api.nvim_create_autocmd("FileType", {
			desc = "Notify to install TS parsers",
			group = vim.api.nvim_create_augroup("TSnotify", {}),
			callback = function()
				local parsers = require("nvim-treesitter.parsers")
				local lang = parsers.get_buf_lang()
				if not parsers.has_parser(lang) and parsers.get_parser_configs()[lang] then
					vim.notify("TS parser can be installed with :TSInstall " .. lang)
				end
			end,
		})
	end,
}
