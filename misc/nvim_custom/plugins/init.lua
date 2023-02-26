local plugins = {

  ["goolord/alpha-nvim"] = { disable = false }, -- enables dashboard
  ["folke/which-key.nvim"] = { -- enable which-key
    disable = false,
  },
  ["gauteh/vim-cppman"] = {},
  ["vim-pandoc/vim-pandoc"] = {},
  ["vim-pandoc/vim-pandoc-syntax"] = {},
  ["fladson/vim-kitty"] = {},
  ["lambdalisue/suda.vim"] = {},
  ["lervag/vimtex"] = {},
  ["whonore/Coqtail"] = {},
  ["ruudjelinssen/proverif-pi-vim"] = {},

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },

  -- Formatting, linting and diagnostics
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.null-ls"
    end,
  },

  -- Mason LSP installed
  ["williamboman/mason.nvim"] = {
    override_options = {
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",

        -- Javascript
        "typescript-language-server",

        -- Tex
        "texlab",

        -- Python
        "pyright",

        -- shell
        "yaml-language-server",
        "clangd",
        "ocaml-lsp",
      },
    },
  },
}

return plugins
