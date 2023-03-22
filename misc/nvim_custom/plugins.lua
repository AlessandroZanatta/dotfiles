local plugins = {

	-- {"goolord/alpha-nvim", enabled=true}, -- enables dashboard
	{
		"folke/which-key.nvim", -- enable which-key
		enabled = true,
	},
	{ "gauteh/vim-cppman" },
	-- { "vim-pandoc/vim-pandoc" },
	{ "vim-pandoc/vim-pandoc-syntax" },
	{ "fladson/vim-kitty", lazy = false },
	{ "lambdalisue/suda.vim", lazy = false },
	{ "lervag/vimtex", lazy = false },
	{ "whonore/Coqtail", lazy = false },
	{ "ruudjelinssen/proverif-pi-vim", lazy = false },

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("custom.configs.null-ls")
			end,
		},

		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},

	-- Formatting, linting and diagnostics
	-- {
	-- 	"jose-elias-alvarez/null-ls.nvim",
	-- 	after = "nvim-lspconfig",
	-- 	config = function()
	-- 		require("custom.configs.null-ls")
	-- 	end,
	-- },

	-- Mason LSP installed
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- Lua
				"lua-language-server",
				"stylua",

				-- Javascript
				"typescript-language-server",

				-- Tex
				"texlab",

				-- Python
				"pyright",

				-- YAML
				"yaml-language-server",

				-- C/C++
				"clangd",

				-- OCaml
				"ocaml-lsp",

				-- Spell and grammar checking
				"ltex-ls",

				-- Rust
				"rust-analyzer",

				-- Bash scripts
				"bash-language-server",

				-- Solidity (language server)
				"solidity-ls",

				-- Solidity (linting)
				-- "solhint",
			},
		},
	},
}

return plugins
