(tset vim.bo :makeprg "go build 2>&1")
(tset vim.bo :errorformat "%f:%l:%c: %m,%-G#%s")
(vim.api.nvim_command "compiler go")
nil
