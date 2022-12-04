(import-macros {: map!} :hibiscus.vim)

(fn preview []
  (let [path (vim.fn.shellescape (vim.fn.expand "%"))
        wbuf ((. (require :d12bb.utils) :open_float_win))]
    (vim.fn.termopen (.. "glow " path))
    (vim.api.nvim_buf_set_keymap wbuf :n :<esc> ":q<cr>" {})
    nil))

(map! [n :buffer] :<leader>p preview "Preview Markdown")
(if (= (vim.fn.findfile :Makefile) "")
    (vim.cmd ":compiler pandoc"))

nil
