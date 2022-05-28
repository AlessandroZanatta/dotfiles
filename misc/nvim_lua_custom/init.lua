-- GLOBALS
vim.g.coc_config_home = "/home/kalex/dotfiles/misc/coc/"

-- FUNCTIONS
vim.cmd [[ 
  Function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
Endfunction
]]

-- AUTOCMDS
-- vim.cmd "autocmd CursorHold * silent call CocActionAsync('highlight')"
vim.api.nvim_create_autocmd("CursorHold", {
   pattern = "*",
   command = "silent call CocActionAsync('highlight')",
})
