(local M {})

(fn M.open_float_win []
  (let [pbuf (vim.api.nvim_create_buf false true)
        height (. (vim.api.nvim_list_uis) 1 :height)
        width (. (vim.api.nvim_list_uis) 1 :width)]
    (vim.api.nvim_open_win pbuf true
                           {:relative :editor
                            :width (math.floor (* width 0.8))
                            :height (math.floor (* height 0.8))
                            :row (* height 0.1)
                            :col (* width 0.1)
                            :style :minimal
                            :border :rounded})
    pbuf))

(fn M.lazygit []
  (let [gitroot (vim.fn.fnamemodify (vim.fn.finddir :.git ";") ":h")]
    (M.open_float_win)
    (vim.fn.termopen (.. "lazygit -p " gitroot)
                     {:on_exit (fn []
                                 (vim.cmd :q))})
    (vim.cmd :startinsert)))

M
