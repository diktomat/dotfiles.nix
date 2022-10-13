(import-macros {: map!} :hibiscus.vim)

(local wk (require :which-key))
(local tsb (require :telescope.builtin))
(local dash (require :dash))
(local ls (require :luasnip))

(wk.setup)

;; Misc
(map! [n] :U :<cmd>redo<cr> :Redo)
(map! [t] :<esc><esc> (vim.api.nvim_replace_termcodes "<C-\\><C-n>" true true true) "Escape Terminal")
(map! [is] :<C-j> #(if (ls.expand_or_jumpable) (ls.expand_or_jump)))
(map! [is] :<C-k> #(if (ls.jumpable (- 1)) (ls.jump (- 1))))
(map! [i] :<C-l> #(if (ls.choice_active) (ls.change_choice 1)))
(map! [n] :<C-b> `((. (require :lspsaga.action) :smart_scroll_with_saga) (- 1)))
(map! [n] :<C-f> `((. (require :lspsaga.action) :smart_scroll_with_saga) 1))

;; Space Mode
;; Missing: Window cmds and clipboard
(map! [n] :<leader>f tsb.git_files "File Picker")
(map! [n] :<leader>F tsb.find_files "File Picker for CWD")
(map! [n] :<leader>b tsb.buffers "Buffer Picker")
(map! [n] :<leader>j tsb.jumplist "Jumplist Picker")
(map! [n] :<leader>s tsb.lsp_document_symbols "Symbol Picker")
(map! [n] :<leader>S tsb.lsp_workspace_symbols "Workspace Symbol Picker")
(map! [n] :<leader>g #(tsb.diagnostics {:bufnr 0}))
(map! [n] :<leader>G tsb.diagnostics "Workspace Diagnostic Picker")
(map! [n] :<leader>a (. (require :lspsaga.codeaction) :code_action) "Code Action")
(map! [n] "<leader>'" tsb.resume "Resume Last Picker")
(map! [n] :<leader>/ tsb.live_grep "Live Grep")
(map! [n] :<leader>k vim.lsp.buf.hover "Hover Info")
(map! [n] :<leader>r (. (require :lspsaga.rename) :lsp_rename) "Rename Symbol")
;; TODO (map! [n] :<leader>h tsb.lsp_references "Highlight References to Symbol")
(map! [n] :<leader>? tsb.commands "Command Palette")

(map! [n] :<leader>h tsb.help_tags "Vim Help")
(map! [n] :<leader>H tsb.man_pages "Man Pages")
(map! [n] :<leader>d dash.search :Dash)
(map! [n] :<leader>e (. (require :lspsaga.diagnostic) :show_line_diagnostics) "Explain Diagnostic")
(map! [n] :<leader>gq vim.lsp.buf.format "Format Buffer")
(map! [n] :<leader>og (. (require :d12bb.utils) :lazygit) :Lazygit)
(map! [n] :<leader>ot (. (require :lspsaga.floaterm) :open_float_terminal) :Terminal)
(map! [n] :<leader>K :<cmd>DashWord<cr> "Dash Word")

;; Goto Mode
(map! [n] :ge :G "Goto Last Line")
(map! [n] :gh :0 "Goto Line Start")
(map! [n] :gl "$" "Goto Line End")
(map! [n] :gs "^" "Goto First Non-Blank in Line")
(map! [n] :gd (. (require :lspsaga.definition) :peek_definition) "Preview Definition")
(map! [n] :gD vim.lsp.buf.definition "Goto Definition")
(map! [n] :gy vim.lsp.buf.type_definition "Goto Type Definition")
(map! [n] :gr tsb.lsp_references "Goto References")
(map! [n] :gR (. (require :lspsaga.finder) :lsp_finder) "Definition & References")
(map! [n] :gi vim.lsp.buf.implementation "Goto Implementation")
(map! [n] :gt :H "Goto Window Top")
(map! [n] :gc :M "Goto Window Center")
(map! [n] :gb :L "Goto Window Bottom")
;; TODO: (map! [n] :ga "Goto Last Accessed File")
;; TODO: (map! [n] :gm "Goto Last Modified File")
(map! [n] :gn :<cmd>bn<cr> "Goto Next Buffer")
(map! [n] :gp :<cmd>bp<cr> "Goto Previous Buffer")
;; TODO: (map! [n] :g. "Goto Last Modification")

;; Left Bracket Mode
;; Textobjects: see misc.fnl
(wk.register {"[" {:name :Previous...}})
(map! [n] "[d" (. (require :lspsaga.diagnostic) :goto_prev) "Goto Previous Diagnostic")
;; TODO: (map! [n] "[D" vim.foo "Goto First Diagnostic")
;; TODO: (map! [n] "[t" "Goto Previous Test")
(map! [n] "[p" "{" "Goto Previous Paragraph")
(map! [n] "[<space>" :O "Add Newline Above")

;; Right Bracket Mode
;; Textobjects: see misc.fnl
(wk.register {"]" {:name :Next...}})
(map! [n] "]d" (. (require :lspsaga.diagnostic) :goto_next) "Goto Next Diagnostic")
;; TODO: (map! [n] "]D" "Goto Last Diagnostic")
;; TODO: (map! [n] "]t" "Goto Next Test")
(map! [n] "]p" "}" "Goto Next Paragraph")
(map! [n] "]<space>" :o "Add Newline below")
