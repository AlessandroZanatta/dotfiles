local M = {}

M.disabled = {
  n = {
      ["<leader>q"] = "",
      ["K"] = "",
  }
}

M.keys = {

	n = {
		["K"] = { ":Man<CR>", "Open manual" },
		["<leader>q"] = { ":q<CR>", "Close" },
	},
}

return M
