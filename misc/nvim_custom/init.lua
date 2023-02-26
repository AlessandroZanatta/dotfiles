-- AUTOCMDS

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.pv",
  command = "set filetype=proverifpi",
})
-- GLOBALS
-- vim.g.vimtex_format_enabled = true
vim.g.coqtail_noimap = true

-- MISC
-- Enable needed providers back (NVChad disables all of them by default)
-- local enable_providers = {
--   "python3_provider",
--   "node_provider",
-- }
--
-- for _, plugin in pairs(enable_providers) do
--   vim.g["loaded_" .. plugin] = nil
--   vim.cmd("runtime " .. plugin)
-- end
