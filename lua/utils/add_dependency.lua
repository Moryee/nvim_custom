local M = {}

-- Checks if a module is installed; if not, adds it via your pack manager
function M.add_dependency(module_name, pack_args)
  if not pcall(require, module_name) then
    vim.pack.add(pack_args)
  end
end

return M

