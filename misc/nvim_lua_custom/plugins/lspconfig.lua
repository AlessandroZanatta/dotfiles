local M = {}

M.setup_lsp = function(_, _)
   local lspconfig = require "lspconfig"
   lspconfig.sumneko_lua.setup {}
end

return M
