local ok, null_ls = pcall(require, "null-ls")
if not ok then
   return {}
end
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

      -- format on save
      on_attach = function(client)
         if client.resolved_capabilities.document_formatting then
            vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
         end
      end,
   }
end

return M
