require("nvchad.configs.lspconfig").defaults()

local servers = {
  -- Lua
  "lua_ls",
  -- Python
  "ruff",
  "pyright",
  -- HTML and CSS
  "html",
  "cssls",
  -- Javascript/Typescript
  -- "biome",
  -- "ts_ls",
  -- "vtsls",
  -- Terraform
  "terraformls",
  "tflint",
  -- Tex
  "texlab",
  -- YAML
  "yamlls",
  -- C/C++
  "clangd",
  -- Bash
  "bashls",
  -- Ansible
  "ansiblels",
  -- Go
  "gopls",
  -- Typos
  "typos_lsp",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
