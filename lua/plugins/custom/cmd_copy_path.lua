vim.api.nvim_create_user_command('UserCopyPath', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path) -- '+' is the system clipboard register
  print("Copied: " .. path)
end, { desc = "Copy relative file path to system clipboard" })

