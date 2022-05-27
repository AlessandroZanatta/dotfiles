local userPlugins = require("custom.plugins")

local M = {}

M.ui = {
	theme = "gruvchad",
}

M.plugins = {
	user = userPlugins,
	remove = {
		"ray-x/lsp_signature.nvim",
		"rafamadriz/friendly-snippets",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"windwp/nvim-autopairs",
		"neovim/nvim-lspconfig",
		"williamboman/nvim-lsp-installer",
	},

	options = {
		lspconfig = {
			setup_lspconf = "custom.plugins.lspconfig",
		},
	},
}

M.mappings = require("custom.mappings")

return M
