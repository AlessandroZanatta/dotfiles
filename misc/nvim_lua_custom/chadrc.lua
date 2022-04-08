local userPlugins = require "custom.plugins"
local null_ls = require "custom.plugins.null-ls"

local M = {}

M.ui = {
   theme = "gruvchad",
}

M.plugins = {
   install = userPlugins,
   default_plugin_remove = {
      "ray-x/lsp_signature.nvim",
      "rafamadriz/friendly-snippets",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "windwp/nvim-autopairs",
   },
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },
}

null_ls.setup()

return M
