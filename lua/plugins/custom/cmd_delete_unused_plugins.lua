vim.api.nvim_create_user_command('UserDeleteUnusedPlugins', function()
  local unused = {}
  for _, p in ipairs(vim.pack.get()) do
    if not p.active then
      table.insert(unused, p.spec.name)
    end
  end

  if #unused > 0 then
    vim.pack.del(unused)
    print("Cleaned up unused plugins: " .. table.concat(unused, ", "))
  else
    print("No unused plugins found")
  end
end, { desc = "Delete inactive plugins and update lockfile" })

