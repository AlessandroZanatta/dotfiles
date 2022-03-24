local userPlugins = require "custom.plugins"
local null_ls = require "custom.plugins.null-ls"

local M = {}

M.ui = {
   theme = "gruvchad",
}

M.plugins = {
   install = userPlugins,
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.lspconfig",
      },
   },
}

null_ls.setup()

return M
