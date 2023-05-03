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

return M
