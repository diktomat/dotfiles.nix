(import-macros {: map!} :hibiscus.vim)

(local capabilities
       ((. (require :cmp_nvim_lsp) :update_capabilities) (vim.lsp.protocol.make_client_capabilities)))

(fn lsp_attach [client buf]
  (vim.api.nvim_create_autocmd :BufWritePre
                               {:group (vim.api.nvim_create_augroup :autoformat
                                                                    {:clear true})
                                :buffer buf
                                :desc "Autoformat on save"
                                :callback #(vim.lsp.buf.format)})
  (vim.api.nvim_buf_set_option buf :formatexpr "v:lua.vim.lsp.formatexpr()")
  (if (not= client.name :null-ls)
      (do
        (vim.api.nvim_buf_set_option buf :omnifunc "v:lua.vim.lsp.omnifunc")
        (vim.api.nvim_buf_set_option buf :tagfunc "v:lua.vim.lsp.tagfunc"))))

(let [go (require :go)]
  (go.setup {:dap_debug false
             :disable_per_project_cfg true
             :lsp_cfg {: capabilities}
             :lsp_diag_hdlr false
             :lsp_format_on_save false
             :lsp_gofumpt true
             :lsp_keymaps false
             :lsp_on_client_start lsp_attach
             :textobjects false
             :verbose_tests false}))

(let [null-ls (require :null-ls)
      nlb null-ls.builtins]
  (null-ls.setup {:sources [nlb.formatting.fnlfmt
                            nlb.formatting.stylua
                            nlb.formatting.swiftformat]
                  :on_attach lsp_attach}))

(let [rust (require :rust-tools)]
  (rust.setup {:server {: capabilities
                        :on_attach (fn [client buf]
                                     (vim.api.nvim_create_autocmd [:BufEnter
                                                                   :CursorHold
                                                                   :InsertLeave]
                                                                  {:group (vim.api.nvim_create_augroup :codelens
                                                                                                       {:clear true})
                                                                   :buffer buf
                                                                   :desc "Refresh Codelens"
                                                                   :callback #(vim.lsp.codelens.refresh)})
                                     (vim.keymap.set :n :<leader>cl
                                                     vim.lsp.codelens.run
                                                     {:desc "Run Codelens"})
                                     (vim.keymap.set :n :<leader>cr
                                                     (. (require :rust-tools.runnables)
                                                        :runnables)
                                                     {:desc "Rust Runnables"})
                                     (vim.cmd "hi link LspCodeLens Comment")
                                     (vim.cmd "hi link LspCodeLensSeparator Comment")
                                     (lsp_attach client buf))}}))

(let [lspc (require :lspconfig)]
  (lspc.sourcekit.setup {: capabilities :on_attach lsp_attach}))

(let [lspc (require :lspconfig)]
  (lspc.sumneko_lua.setup {: capabilities
                           :on_attach lsp_attach
                           :settings {:Lua {:format {:enable false}
                                            :runtime {:version :LuaJIT
                                                      :path (vim.split package.path
                                                                       ";")}
                                            :diagnostics {:globals [:vim]}
                                            :workspace {:library {(vim.fn.expand :$VIMRUNTIME/lua) true
                                                                  (vim.fn.expand :$VIMRUNTIME/lua/vim/lsp) true}}
                                            :telemetry {:enable false}}}}))
