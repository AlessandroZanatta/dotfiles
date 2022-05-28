-- AUTOCMDS
vim.api.nvim_create_autocmd("CursorHold", {
   command = "silent call CocActionAsync('highlight')",
})

-- GLOBALS
vim.g.coc_config_home = "/home/kalex/dotfiles/misc/coc/"

-- FUNCTIONS
vim.cmd [[ 
  Function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  Endfunction
]]
