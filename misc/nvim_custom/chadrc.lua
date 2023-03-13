local M = {}

local highlights = require("custom.highlights")

M.ui = {
	theme = "kanagawa",
	hl_override = highlights.override,
	hl_add = highlights.add,
	statusline = { theme = "default", separator_style = "round" },
}

M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

return M
