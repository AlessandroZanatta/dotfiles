-- AUTOCMDS
vim.api.nvim_create_autocmd("CursorHold", {
  command = "silent call CocActionAsync('highlight')",
})

-- GLOBALS
vim.g.coc_config_home = "/home/kalex/dotfiles/misc/coc/"
vim.g.coc_filetype_map = { tex = "latex" }
vim.g.coc_snippet_next = "<tab>"
vim.g.vimtex_format_enabled = true
vim.g.coqtail_noimap = true

-- COMMANDS
vim.cmd "highlight CocHighlightText guifg=#2b2922 guibg=#d19a66"

-- MISC
-- Enable needed providers back (NVChad disables all of them by default)
local enable_providers = {
  "python3_provider",
  "node_provider",
}

for _, plugin in pairs(enable_providers) do
  vim.g["loaded_" .. plugin] = nil
  vim.cmd("runtime " .. plugin)
end

-- use <tab> for trigger completion and navigate to the next complete item
-- TODO: porting to lua the inoremap mapping is buggy, even though it does work (see mappings.lua)
vim.cmd [[
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()
]]

-- local coqtailGrp = vim.api.nvim_create_augroup("CoqtailHighlights", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function()
--     vim.api.nvim_set_hl(0, "CoqtailChecked", { ctermbg = 10, bg = DarkGreen })
--     vim.api.nvim_set_hl(0, "CoqtailSent", { ctermbg = 10, bg = DarkGreen })
--   end,
--   group = coqtailGrp,
-- })
--
-- vim.api.nvim_set_hl(0, "CoqtailChecked", { ctermbg = 10, bg = DarkGreen })
-- vim.api.nvim_set_hl(0, "CoqtailSent", { ctermbg = 0, bg = DarkBlue })
