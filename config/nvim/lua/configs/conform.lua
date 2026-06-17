local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    html = { "biome-check" },
    css = { "biome-check" },
    javascript = { "biome-check" },
    javascriptreact = { "biome-check" },
    typescript = { "biome-check" },
    typescriptreact = { "biome-check" },
    markdown = { "prettier" },
    go = { "gofmt" },
    rust = { "rustfmt" },
    json = { "biome-check" },
    yaml = { "prettier" },
    ansible = { "ansible-lint" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    terraform = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
    sh = { "shfmt", "shellcheck", "shellharden" },
    sql = { "sql_formatter" },
  },

  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
}

return options
