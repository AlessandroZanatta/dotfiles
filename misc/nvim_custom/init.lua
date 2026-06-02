-- AUTOCMDS

-- vim.api.nvim_create_autocmd("BufRead", {
-- 	pattern = "*.pv",
-- 	command = "set filetype=proverifpi",
-- })
-- GLOBALS
-- vim.g.vimtex_format_enabled = true
-- vim.g.coqtail_noimap = true

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

-- Disable annoying warnings that may not get fixed soon
-- local notify = vim.notify
-- vim.notify = function(msg, ...)
-- 	if
-- 		msg:match("warning: multiple different client offset_encodings detected for buffer, this is not supported yet")
-- 	then
-- 		return
-- 	end
--
-- 	notify(msg, ...)
-- end

-- Sops encrypt/decrypt
vim.api.nvim_create_user_command("Sops", function()
  -- Get the current file path
  local file_path = vim.api.nvim_buf_get_name(0)

  -- Construct the command
  local command_parts = { "just", "sops", file_path }

  -- Use vim.fn.system() to execute the command.
  -- This is a synchronous call but is generally safer than os.execute()
  -- for simple shell commands and properly integrates with Neovim's I/O.
  -- The function returns the output of the command, which we can ignore.
  vim.fn.system(command_parts)

  -- Check the return status (optional but good practice)
  -- The exit code is stored in v:shell_error after vim.fn.system() runs.
  if vim.v.shell_error ~= 0 then
    print("Sops command failed!")
    return
  end

  -- Reload the buffer to reflect changes made by the command
  -- This should only happen after the command has successfully finished
  vim.cmd("edit")
end, {
  nargs = 0,
})
