local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {

	-- HTML, JS, TS, CSS, HTML, JSON, and Markdown
	b.formatting.prettier,

	-- Markdown
	b.diagnostics.mdl,

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
