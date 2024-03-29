local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {

	-- HTML, JS, TS, CSS, HTML, JSON, Markdown, and Solitidy
	b.formatting.prettier.with({
		extra_filetypes = { "solidity" },
	}),

	-- Markdown (prettier already provides this)
	-- b.diagnostics.mdl,

	-- Lua
	b.formatting.stylua,

	-- Python
	b.formatting.black,

	-- C/C++
	b.diagnostics.cppcheck,
	b.formatting.clang_format,

	-- Makefile
	b.formatting.cmake_format,

	-- PHP
	b.diagnostics.php,

	-- LaTeX
	b.formatting.latexindent.with({
		extra_args = { "-m", "-l", "/home/kalex/dotfiles/misc/latexindent/textwrap.yaml" },
	}),

	-- OCaml
	b.formatting.ocamlformat,

	-- Rust
	b.formatting.rustfmt,

	-- Verilog
	b.formatting.verible_verilog_format,

	-- Shell
	b.formatting.shfmt,
	b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
	b.formatting.shellharden,

	-- Solidity
	-- b.diagnostics.solhint,

	-- Golang
	b.formatting.gofmt,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	debug = true,
	sources = sources, -- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use
					vim.lsp.buf.format({ bufnr = bufnr })
					-- vim.lsp.buf.formatting_sync()
				end,
			})
		end
	end,
})
