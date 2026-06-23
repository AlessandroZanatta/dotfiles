return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "kyazdani42/nvim-tree.lua",
    opts = {
      git = {
        ignore = false,
      },
    },
  },

  { "rcarriga/nvim-notify" },

  {
    "greggh/claude-code.nvim",
    lazy = false,
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("claude-code").setup()
    end,
    opts = {},
  },

  -- Typescript LSP, but faster
  {
    "pmizio/typescript-tools.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  -- Mermaid
  {
    "kevalin/mermaid.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    config = function()
      require("mermaid").setup()

      -- Install the Tree-sitter parser:
      -- :TSInstall mermaid
    end,
  },

  { "towolf/vim-helm", ft = "helm", lazy = false },
  {
    "qvalentin/helm-ls.nvim",
    ft = "helm",
    lazy = false,
    opts = {
      ensure_installed = {
        -- "helm",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "mermaid",
        "yaml",
        "go",
        "gotmpl",
        -- "helm",
      },
    },
  },
}
