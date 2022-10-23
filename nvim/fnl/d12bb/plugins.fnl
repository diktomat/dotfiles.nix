(import-macros {: packer : packer-setup : use!} :hibiscus.packer)

(packer-setup {:display {:open_fn #((. (require :packer.util) :float) {:border :rounded})}})

;; fnlfmt: skip
(packer (use! :windwp/nvim-autopairs)
        (use! :hrsh7th/nvim-cmp)
          (use! :hrsh7th/cmp-buffer)
          (use! :hrsh7th/cmp-cmdline)
          (use! :hrsh7th/cmp-nvim-lua)
          (use! :hrsh7th/cmp-nvim-lsp)
          (use! :hrsh7th/cmp-nvim-lsp-signature-help)
          (use! :hrsh7th/cmp-path)
        (use! :numToStr/Comment.nvim)
        (use! :mrjones2014/dash.nvim :run "make install")
        (use! :gpanders/editorconfig.nvim)
        (use! :j-hui/fidget.nvim)
        (use! :ray-x/go.nvim)
        (use! :luisiacc/gruvbox-baby)
        (use! :udayvir-singh/hibiscus.nvim)
        (use! :neovim/nvim-lspconfig)
        (use! :onsails/lspkind.nvim)
        (use! :glepnir/lspsaga.nvim)
        (use! :nvim-lualine/lualine.nvim
              :requires [:kyazdani42/nvim-web-devicons])
        (use! :L3MON4D3/LuaSnip)
          (use! :saadparwaiz1/cmp_luasnip)
        (use! :jose-elias-alvarez/null-ls.nvim
              :requires [:nvim-lua/plenary.nvim])
        (use! :simrat39/rust-tools.nvim)
        (use! :udayvir-singh/tangerine.nvim)
        (use! :nvim-telescope/telescope.nvim
              :requires [:kyazdani42/nvim-web-devicons :nvim-lua/plenary.nvim])
        (use! :nvim-telescope/telescope-fzf-native.nvim
              :run :make)
        (use! :nvim-treesitter/nvim-treesitter
              :run ":TSUpdate")
          (use! "https://git.sr.ht/~p00f/nvim-ts-rainbow")
          (use! :nvim-treesitter/nvim-treesitter-context)
          (use! :nvim-treesitter/nvim-treesitter-textobjects)
        (use! :folke/which-key.nvim))
