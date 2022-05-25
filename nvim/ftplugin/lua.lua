vim.bo.include = "^\\s*require"
vim.bo.includeexpr = "substitute(v:fname,'\\.','/','g')"
vim.bo.suffixesadd = "init.lua," .. vim.bo.suffixesadd
vim.bo.formatprg = "stylua -"
vim.bo.textwidth = 120
require("which-key").register({ ["<leader>gq"] = { "<cmd>w |!stylua %<cr>", "Format File" } }, { buffer = 0 })
