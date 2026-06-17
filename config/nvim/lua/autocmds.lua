require "nvchad.autocmds"

local conform = require "conform"
local notify = require "notify"

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
    print "Sops command failed!"
    return
  end

  -- Reload the buffer to reflect changes made by the command
  -- This should only happen after the command has successfully finished
  vim.cmd "edit"
end, {
  nargs = 0,
})

-- Toggle autoformat from Conform
-- https://github.com/stevearc/conform.nvim/issues/39#issuecomment-1937061763
local function show_notification(message, level)
  notify(message, level, { title = "conform.nvim" })
end

vim.api.nvim_create_user_command("FormatToggle", function(args)
  local is_global = not args.bang
  if is_global then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    if vim.g.disable_autoformat then
      show_notification("Autoformat-on-save disabled globally", "info")
    else
      show_notification("Autoformat-on-save enabled globally", "info")
    end
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    if vim.b.disable_autoformat then
      show_notification("Autoformat-on-save disabled for this buffer", "info")
    else
      show_notification("Autoformat-on-save enabled for this buffer", "info")
    end
  end
end, {
  desc = "Toggle autoformat-on-save",
  bang = true,
})
