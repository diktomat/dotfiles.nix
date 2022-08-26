(tset vim.bo :include "^\\s*require")
(tset vim.bo :includeexpr "substitute(v:fname,'\\.','/','g')")
(tset vim.bo :suffixesadd (.. "init.lua," vim.bo.suffixesadd))
(tset vim.bo :textwidth 120)
nil
