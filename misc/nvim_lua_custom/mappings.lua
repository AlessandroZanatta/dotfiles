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
    ["[g"] = { "<Plug>(coc-diagnostic-prev)", "Coc: goto previous diagnostic" },
    ["]g"] = { "<Plug>(coc-diagnostic-next)", "Coc: goto next diagnostic" },
    ["gd"] = { "<Plug>(coc-definition)", "Coc: goto definition" },
    ["gy"] = { "<Plug>(coc-type-definition)", "Coc: goto type definition" },
    ["gi"] = { "<Plug>(coc-implementation)", "Coc: goto implementation" },
    ["gr"] = { "<Plug>(coc-references)", "Coc: goto references" },
    ["<leader>cl"] = { "<Plug>(coc-codelens-action)", "Coc: code lens action" },
  },

  -- This actually works (autocomplete correctly), but it's extremely buggy: when completing, vim seems to freeze until a few characters are sent. Sticking to vim.cmd for now
  -- i = {
  --     ["<TAB>"] = {
  --       [[coc#pum#visible() ? coc#_select_confirm() : coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : CheckBackSpace() ? "\<TAB>" : coc#refresh()]],
  --       "Coc: trigger autocompletion and navigate",
  --       opts = { silent = true, expr = true },
  --     },
  --   },

  -- coc-snippets suggested bindings
  -- i = {
  --   ["<C-l>"] = { "<Plug>(coc-snippets-expand)" },
  --   ["<C-j>"] = { "<Plug>(coc-snippets-expand-jump)" },
  -- },
  -- v = {
  --   ["<C-j>"] = { "<Plug>(coc-snippets-select)" },
  -- },
  -- x = {
  --   ["<leader>x"] = { "<Plug>(coc-convert-snippet)" },
  -- },
}

return M
