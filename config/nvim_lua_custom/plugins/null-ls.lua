local null_ls = require "null-ls"
local formatting = null_ls.builtins.formatting

local sources = {
   formatting.stylua,
   formatting.clang_format.with { extra_args = { "-style", "{IndentWidth: 4}" } },
   formatting.latexindent,
}

local M = {}

M.setup = function()
   null_ls.setup {
      debug = true,
      sources = sources,
      on_attach = function(client)
         if client.resolved_capabilities.document_formatting then
            vim.cmd [[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]]
         end
      end,
   }
end

return M
