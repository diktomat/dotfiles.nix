(import-macros {: map!} :hibiscus.vim)

(local wk (require :which-key))
(local tsb (require :telescope.builtin))
(local dash (require :dash))
(local ls (require :luasnip))

(wk.setup)

;; Misc
(map! [n] :U :<cmd>redo<cr> :Redo)
(map! [i] :<C-l> #(if (ls.choice_active) (ls.change_choice 1)))
(map! [is] :<C-j> #(if (ls.expand_or_jumpable) (ls.expand_or_jump)))
(map! [is] :<C-k> #(if (ls.jumpable (- 1)) (ls.jump (- 1))))
(map! [t] :<esc><esc>
      (vim.api.nvim_replace_termcodes "<C-\\><C-n>" true true true)
      "Escape Terminal")

;; Space Mode
;; Missing: Window cmds and clipboard
;; TODO (map! [n] :<leader>h tsb.lsp_references "Highlight References to Symbol")
(map! [n] :<leader>f tsb.git_files "File Picker")
(map! [n] :<leader>F tsb.find_files "File Picker for CWD")
(map! [n] :<leader>b tsb.buffers "Buffer Picker")
(map! [n] :<leader>j tsb.jumplist "Jumplist Picker")
(map! [n] :<leader>s tsb.lsp_document_symbols "Symbol Picker")
(map! [n] :<leader>S tsb.lsp_workspace_symbols "Workspace Symbol Picker")
(map! [n] :<leader>g #(tsb.diagnostics {:bufnr 0}))
(map! [n] "<leader>'" tsb.resume "Resume Last Picker")
(map! [n] :<leader>/ tsb.live_grep "Live Grep")
(map! [n] :<leader>G tsb.diagnostics "Workspace Diagnostic Picker")
(map! [n] :<leader>? tsb.commands "Command Palette")
(map! [nv] :<leader>A "<cmd>Lspsaga code_action<cr>" "Code Action")
(map! [n] :<leader>k "<cmd>Lspsaga hover_doc<cr>" "Hover Info")
(map! [n] :<leader>r "<cmd>Lspsaga rename<cr>" "Rename Symbol")

(map! [n] :<leader>h tsb.help_tags "Vim Help")
(map! [n] :<leader>H tsb.man_pages "Man Pages")
(map! [n] :<leader>d dash.search :Dash)
(map! [n] :<leader>gq vim.lsp.buf.format "Format Buffer")
(map! [n] :<leader>og (. (require :d12bb.utils) :lazygit) :Lazygit)
(map! [n] :<leader>ot "<cmd>Lspsaga open_floaterm<cr>" :Terminal)
(map! [n] :<leader>K :<cmd>DashWord<cr> "Dash Word")
(map! [n] :<leader>e "<cmd>Lspsaga show_line_diagnostics<cr>"
      "Explain Diagnostic")

;; Goto Mode
;; TODO: (map! [n] :gm "Goto Last Modified File")
(map! [n] :ge :G "Goto Last Line")
(map! [n] :gh :0 "Goto Line Start")
(map! [n] :gl "$" "Goto Line End")
(map! [n] :gs "^" "Goto First Non-Blank in Line")
(map! [n] :g. "`." "Goto Last Modification")
(map! [n] :ga :<C-^> "Goto Last Accessed File")
(map! [n] :gd "<cmd>Lspsaga peek_definition<cr>" "Preview Definition")
(map! [n] :gD vim.lsp.buf.definition "Goto Definition")
(map! [n] :gy vim.lsp.buf.type_definition "Goto Type Definition")
(map! [n] :gr tsb.lsp_references "Goto References")
(map! [n] :gR "<cmd>Lspsaga lsp_finder<cr>" "Definition & References")
(map! [n] :gi vim.lsp.buf.implementation "Goto Implementation")
(map! [n] :gt :H "Goto Window Top")
(map! [n] :gc :M "Goto Window Center")
(map! [n] :gb :L "Goto Window Bottom")
(map! [n] :gn :<cmd>bn<cr> "Goto Next Buffer")
(map! [n] :gp :<cmd>bp<cr> "Goto Previous Buffer")

;; Left Bracket Mode
;; Textobjects: see misc.fnl
;; TODO: (map! [n] "[D" vim.foo "Goto First Diagnostic")
;; TODO: (map! [n] "[t" "Goto Previous Test")
(wk.register {"[" {:name :Previous...}})
(map! [n] "[p" "{" "Goto Previous Paragraph")
(map! [n] "[<space>" :O "Add Newline Above")
(map! [n] "[d" "<cmd>Lspsaga diagnostic_jump_prev<cr>"
      "Goto Previous Diagnostic")

;; Right Bracket Mode
;; Textobjects: see misc.fnl
;; TODO: (map! [n] "]D" "Goto Last Diagnostic")
;; TODO: (map! [n] "]t" "Goto Next Test")
(wk.register {"]" {:name :Next...}})
(map! [n] "]p" "}" "Goto Next Paragraph")
(map! [n] "]<space>" :o "Add Newline below")
(map! [n] "]d" "<cmd>Lspsaga diagnostic_jump_prev<cr>" "Goto Next Diagnostic")
