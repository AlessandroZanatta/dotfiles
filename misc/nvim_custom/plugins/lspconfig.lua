local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

local servers = { "clangd", "ocamllsp", "rust_analyzer", "texlab", "tsserver", "yamlls", "pyright" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- We need to add settings to ltex
lspconfig.ltex.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		ltex = {
			language = "en-GB",
			enabled = { "latex", "markdown" }, -- may not be needed
			additionalRules = { motherTongue = "it", languageModel = "/usr/share/ngrams/" },
		},
	},
})
