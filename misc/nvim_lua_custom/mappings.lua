local M = {}

M.disabled = {
   n = {
      ["<leader>q"] = "",
      ["K"] = "",
      ["<leader>f"] = "",
   },
}

M.utils = {
   n = {
      ["K"] = { ":Man<CR>", "Open manual" },
      ["<leader>q"] = { ":q<CR>", "Close" },
   },
}

M.coc = {
   n = {
      ["<leader>rn"] = { "<Plug>(coc-rename)", "Coc: rename instances" },
      ["<leader>a"] = { "<Plug>(coc-codeaction-selected)", "Coc: apply code action on region" },
      ["<leader>ac"] = { "<Plug>(coc-codeaction)", "Coc: apply code action on buffer" },
      ["<leader>f"] = { "<Plug>(coc-fix-current)", "Coc: apply auto fix" },
   },
}

M.coc_silent = {
   mode_opts = { silent = true },
   n = {
      ["[g"] = { "<Plug>(coc-diagnostic-prev)", "Coc: goto previous diagnostic" },
      ["]g"] = { "<Plug>(coc-diagnostic-next)", "Coc: goto next diagnostic" },
      ["gd"] = { "<Plug>(coc-definition)", "Coc: goto definition" },
      ["gy"] = { "<Plug>(coc-type-definition)", "Coc: goto type definition" },
      ["gi"] = { "<Plug>(coc-implementation)", "Coc: goto implementation" },
      ["gr"] = { "<Plug>(coc-references)", "Coc: goto references" },
      ["<leader>cl"] = { "<Plug>(coc-codelens-action)", "Coc: code lens action" },
   },
}

-- M.coc_silent_expr = {
--    mode_opts = { silent = true, expr = true },
--    i = {
--       ["<TAB>"] = {
--          'pumvisible() ? "\\<C-n>" : CheckBackspace() ? "\\<TAB>" : coc#refresh()',
--          "Coc: trigger autocompletion and navigate",
--       },
--       ["<c-space>"] = { "coc#refresh()", "Coc: trigger completion" },
--    },
-- }

return M
