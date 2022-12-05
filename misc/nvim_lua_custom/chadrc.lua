local userPlugins = require "custom.plugins"

local M = {}

M.ui = {
  theme = "gruvchad",
  hl_add = require "custom.highlights",
}
M.plugins = require "custom.plugins"
M.mappings = require "custom.mappings"

return M
