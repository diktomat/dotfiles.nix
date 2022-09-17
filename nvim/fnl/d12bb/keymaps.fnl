(import-macros {: map!} :hibiscus.vim)

(local M {})
(local wk (require :which-key))
(local tsb (require :telescope.builtin))
(local dash (require :dash))
(local ls (require :luasnip))

(wk.setup)

(fn M.general []
  (wk.register {"[" {:name :Previous...}
                "]" {:name :Next...}
                :<leader>F {:name "Find (Telescope)"}
                :<leader>g {:name :Open...}})
  (map! [n] "[c" :<cmd>cprev<cr> ":cprev")
  (map! [n] "[l" :<cmd>lprev<cr> ":lprev")
  (map! [n] "]c" :<cmd>cnext<cr> ":cnext")
  (map! [n] "]l" :<cmd>lnext<cr> ":lnext")
  (map! [n] :<leader>f tsb.find_files "Find Files")
  (map! [n] :<leader>Fb tsb.buffers :Buffers)
  (map! [n] :<leader>Fg tsb.live_grep "Live Grep")
  (map! [n] :<leader>FG tsb.grep_string "Grep String")
  (map! [n] :<leader>Fh tsb.help_tags "Vim Help")
  (map! [n] :<leader>FH tsb.man_pages "Man Pages")
  (map! [n] :<leader>Fd dash.search :Dash)
  (map! [n] :<leader>Fq tsb.quickfix "Quickfix List")
  (map! [n] :<leader>Fj tsb.jumplist :Jumplist)
  (map! [n] :<leader>gg (. (require :d12bb.utils) :lazygit) :Lazygit)
  (map! [n] :<leader>gt (. (require :lspsaga.floaterm) :open_float_terminal)
        :Terminal)
  (map! [n] :<leader>k :<cmd>DashWord<cr> "Dash Word")
  (map! [t] :<esc><esc>
        `(vim.api.nvim_replace_termcodes "<C-\\><C-n" true true true) ; FIXME
        "Escape Terminal")
  (map! [is] :<C-j>
        (fn []
          (if (ls.expand_or_jumpable) (ls.expand_or_jump))))
  (map! [is] :<C-k>
        (fn []
          (if (ls.jumpable (- 1)) (ls.jump (- 1)))))
  (map! [i] :<C-l>
        (fn []
          (if (ls.choice_active) (ls.change_choice 1)))))

(fn M.lsp [buf]
  (map! [n :buffer] :gd (. (require :lspsaga.definition) :peek_definition)
        "Preview Definition")
  (map! [n :buffer] :gD vim.lsp.buf.definition "Goto Definition")
  (map! [n :buffer] :gh (. (require :lspsaga.finder) :lsp_finder)
        "Definition & References")
  (map! [n :buffer] :K vim.lsp.buf.hover "Hover Info")
  (map! [n :buffer] :<leader>q vim.diagnostic.setqflist "Diagnostics -> QFlist")
  (map! [n :buffer] "[d" (. (require :lspsaga.diagnostic) :goto_prev)
        "Previous Diagnostic")
  (map! [n :buffer] "]d" (. (require :lspsaga.diagnostic) :goto_next)
        "Next Diagnostic")
  (map! [n :buffer] :<leader>e
        (. (require :lspsaga.diagnostic) :show_line_diagnostics)
        "Explain Diagnostic")
  (map! [n :buffer] :<leader>ca (. (require :lspsaga.codeaction) :code_action)
        "Code Action")
  (map! [n :buffer] :<leaderR (. (require :lspsaga.rename) :lsp_rename)
        "Rename Symbol")
  (map! [n :buffer] :<leader>r tsb.lsp_references "References to Symbol")
  (map! [n :buffer] :<leader>fs tsb.lsp_document_symbols "Document Symbols")
  (map! [n :buffer] :<leader>Fs tsb.lsp_workspace_symbols "Workspace Symbols")
  (map! [n :buffer] :<leader>gq vim.lsp.buf.format "Format Buffer")
  (map! [n :buffer] :<C-b>
        `((. (require :lspsaga.action) :smart_scroll_with_saga) (- 1)))
  (map! [n :buffer] :<C-f>
        `((. (require :lspsaga.action) :smart_scroll_with_saga) 1)))

M
