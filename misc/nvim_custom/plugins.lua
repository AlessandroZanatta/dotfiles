local plugins = {

  -- {"goolord/alpha-nvim", enabled=true}, -- enables dashboard
  {
    "folke/which-key.nvim", -- enable which-key
    enabled = true,
  },
  { "gauteh/vim-cppman" },
  -- { "vim-pandoc/vim-pandoc" },
  { "vim-pandoc/vim-pandoc-syntax" },
  { "fladson/vim-kitty",           lazy = false },
  { "lambdalisue/suda.vim",        lazy = false },
  { "lervag/vimtex",               lazy = false },
  -- { "whonore/Coqtail", lazy = false },
  -- { "ruudjelinssen/proverif-pi-vim", lazy = false },

  { "evanleck/vim-svelte",         lazy = false },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "gbprod/none-ls-shellcheck.nvim",
        "gbprod/none-ls-php.nvim",
      },
      config = function()
        require("custom.configs.none-ls")
      end,
    },
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },

  { "RRethy/vim-illuminate",  lazy = false },
  { "NoahTheDuke/vim-just",   lazy = false },
  { "hashivim/vim-terraform", lazy = false },
  -- { "udalov/kotlin-vim", lazy = false },

  -- Mason LSP installed
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",

        -- Javascript
        "typescript-language-server",
        "eslint-lsp",

        -- Tex
        "texlab",

        -- Python
        "pyright",

        -- YAML
        "yaml-language-server",

        -- C/C++
        "clangd",

        -- OCaml
        "ocaml-lsp",

        -- Spell and grammar checking
        "ltex-ls",

        -- Rust
        "rust-analyzer",

        -- Bash scripts
        "bash-language-server",

        -- Ansible
        "ansible-language-server",

        -- Solidity (language server)
        "solidity-ls",

        -- Solidity (linting)
        -- "solhint",

        -- Go
        "gopls",

        -- Terraform
        "terraform-ls",
      },
    },
  },

  -- {
  -- 	"zbirenbaum/copilot.lua",
  -- 	cmd = "Copilot",
  -- 	event = "InsertEnter",
  -- 	config = function()
  -- 		require("copilot").setup({
  -- 			suggestion = { enabled = false },
  -- 			panel = { enabled = false },
  -- 		})
  -- 	end,
  -- },
  -- {
  -- 	"zbirenbaum/copilot-cmp",
  -- 	config = function()
  -- 		require("copilot_cmp").setup()
  -- 	end,
  -- 	lazy = false,
  -- },
  --
  -- {
  -- 	"hrsh7th/nvim-cmp",
  -- 	opts = function()
  -- 		plugins = require("plugins.configs.cmp")
  -- 		table.insert(plugins.sources, { name = "copilot", group_index = 2 })
  -- 		return plugins
  -- 	end,
  -- },
}

return plugins
