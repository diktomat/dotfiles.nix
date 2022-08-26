(import-macros {: augroup! : set!} :hibiscus.vim)

(augroup! :d12bb
  [[CmdLineEnter] [/ ?] '(set! hlsearch true)]  ; Highlight only when searching
  [[CmdLineLeave] [/ ?] '(set! hlsearch false)] ; Highlight only when searching
  [[BufEnter TermOpen] "term://*" :startinsert] ; Insert only for Terminal buffers
  [[FileType] *                                 ; Notify when TS parser not installed
    '(let [parsers (require :nvim-treesitter.parsers)
           lang (parsers.get_buf_lang)]
      (if (and (not= lang :help)
               (. (parsers.get_parser_configs) lang)
               (not (parsers.has_parser lang)))
        (vim.notify (.. "TS parser can be installed with :TSInstall " lang))))])
