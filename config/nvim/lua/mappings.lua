require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>q", ":q<CR>", { desc = "Close nvim" })
map("n", "<leader>s", ":Sops<CR>", { desc = "Sops encrypt/decrypt via local justfile" })
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open floating LSP diagnostic" })
map("v", "p", "P", { noremap = true, desc = "Do not yank when pasting" })

-- Conform
map("n", "<leader>ct", ":FormatToggle!<CR>", { desc = "Disable autoformat on save for this buffer" })
map("n", "<leader>cT", ":FormatToggle<CR>", { desc = "Disable autoformat on save" })

local nomap = vim.keymap.del

nomap("i", "<Tab>")
