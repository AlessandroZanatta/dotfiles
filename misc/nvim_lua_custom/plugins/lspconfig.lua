local M = {}

M.setup_lsp = function(attach, capabilities)
   local lspconfig = require "lspconfig"

   -- lspconfig.pyright.setup {}
   -- lspconfig.ltex.setup {}
   -- lspconfig.ocamllsp.setup {}
   lspconfig.sumneko_lua.setup {}
end

return M
