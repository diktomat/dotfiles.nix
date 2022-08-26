(local cmp (require :cmp))
(local lspkind (require :lspkind))
(local luasnip (require :luasnip))
(cmp.setup {:formatting {:format (lspkind.cmp_format {:with_text true
                                                      :menu {:buffer "[buf]"
                                                             :nvim_lsp "[lsp]"
                                                             :nvim_lua "[api]"
                                                             :path "[path]"
                                                             :luasnip "[snip]"}})}
            :mapping (cmp.mapping.preset.insert {:<C-b> (cmp.mapping.scroll_docs (- 4))
                                                 :<C-f> (cmp.mapping.scroll_docs 4)})
            :snippet {:expand (fn [args]
                                (luasnip.lsp_expand args.body))}
            :sources (cmp.config.sources [{:name :nvim_lsp}
                                          {:name :nvim_lsp_signature_help}
                                          {:name :nvim_lua}
                                          {:name :luasnip}
                                          {:name :path}]
                                         [{:name :buffer :keyword_length 3}])})

(cmp.setup.cmdline "/"
                   {:mapping (cmp.mapping.preset.cmdline)
                    :sources (cmp.config.sources [{:name :buffer}])})

(cmp.setup.cmdline ":"
                   {:mapping (cmp.mapping.preset.cmdline)
                    :sources (cmp.config.sources [{:name :path}
                                                  {:name :cmdline}])})
