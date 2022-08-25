vim.bo.include = "^\\s*require"
vim.bo.includeexpr = "substitute(v:fname,'\\.','/','g')"
vim.bo.suffixesadd = "init.lua," .. vim.bo.suffixesadd
vim.bo.textwidth = 120
