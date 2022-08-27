(import-macros {: augroup! : set!} :hibiscus.vim)

;; fnlfmt: skip
(augroup! :d12bb
  [[CmdLineEnter :desc "Highlight only when searching" ] [/ ?] '(set! hlsearch true)]
  [[CmdLineLeave :desc "Highlight only when searching" ] [/ ?] '(set! hlsearch false)]
  [[BufEnter TermOpen :desc "Insert only for Terminal buffers"] "term://*" :startinsert]
  [[FileType :desc "Notify when TS parser not installed"] *
    '(let [parsers (require :nvim-treesitter.parsers)
           lang (parsers.get_buf_lang)]
      (if (and (not= lang :help)
               (. (parsers.get_parser_configs) lang)
               (not (parsers.has_parser lang)))
        (vim.notify (.. "TS parser can be installed with :TSInstall " lang))))])
