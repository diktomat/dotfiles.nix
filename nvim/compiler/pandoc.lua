local defaults = vim.fn.matchlist(vim.fn.getline(vim.fn.search('^defaults:', 'n')), '^defaults:\\s*\\(.*\\)$')[2]
defaults = defaults and ' -d '..defaults or ''

vim.bo.makeprg = 'pandoc' .. defaults .. ' -o "%:p:r.pdf" "%:p"'
vim.bo.errorformat = '%f, line %l: %m' -- TODO: proper errorformat for Pandoc and LaTeX

