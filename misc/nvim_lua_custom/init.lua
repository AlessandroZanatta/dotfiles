-- AUTOCMDS
vim.api.nvim_create_autocmd("CursorHold", {
   command = "silent call CocActionAsync('highlight')",
})

-- GLOBALS
vim.g.coc_config_home = "/home/kalex/dotfiles/misc/coc/"

-- COMMANDS
vim.cmd "highlight CocHighlightText guifg=#2b2922 guibg=#d19a66"
