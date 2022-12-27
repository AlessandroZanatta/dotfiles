return {
  ["neoclide/coc.nvim"] = { branch = "release" },
  -- ["jose-elias-alvarez/null-ls.nvim"] = {
  --    after = "nvim-lspconfig",
  --    config = function()
  --       require("custom.plugins.null-ls").setup()
  --    end,
  -- },
  ["gauteh/vim-cppman"] = {},
  ["vim-pandoc/vim-pandoc"] = {},
  ["vim-pandoc/vim-pandoc-syntax"] = {},
  ["goolord/alpha-nvim"] = {
    disable = false,
  },
  ["fladson/vim-kitty"] = {},
  ["lambdalisue/suda.vim"] = {},
  ["lervag/vimtex"] = {},
  -- ["SirVer/ultisnips"] = {}, -- Doesn't look like coc-snippets requires the actual provider
  ["honza/vim-snippets"] = {},
  ["whonore/Coqtail"] = {},
  ["martinda/Jenkinsfile-vim-syntax"] = {},
  ["ruudjelinssen/proverif-pi-vim"] = {},

  ---------------------------------------------------
  ---------------- Modified plugins -----------------
  ---------------------------------------------------
  ["folke/which-key.nvim"] = {
    disable = false,
  },

  ---------------------------------------------------
  ----------------- Removed plugins -----------------
  ---------------------------------------------------
  ["ray-x/lsp_signature.nvim"] = false,
  ["rafamadriz/friendly-snippets"] = false,
  ["hrsh7th/cmp-nvim-lsp"] = false,
  ["hrsh7th/cmp-buffer"] = false,
  ["L3MON4D3/LuaSnip"] = false,
  ["hrsh7th/nvim-cmp"] = false,
  ["saadparwaiz1/cmp_luasnip"] = false,
  ["hrsh7th/cmp-nvim-lua"] = false,
  ["hrsh7th/cmp-path"] = false,
  ["windwp/nvim-autopairs"] = false,
  ["neovim/nvim-lspconfig"] = false,
  ["williamboman/nvim-lsp-installer"] = false,
}
