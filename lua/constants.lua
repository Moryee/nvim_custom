local M = {}

-- TODO: add concat paths util function
local config_dir = vim.fn.expand("~/.config/" .. (vim.env.NVIM_APPNAME or "nvim"))
local prompts_dir = config_dir .. "/ai_prompts"
local prompts_custom_dir = prompts_dir .. "/custom"

M.paths = {
  config_dir = config_dir,
  avante_base_prompts_dir = prompts_dir .. "/base",
}

M.ai_custom_prompts = {
  commit_message = prompts_custom_dir .. "/commit_message.txt",
  unit_tests = prompts_custom_dir .. "/unit_tests.txt",
}

M.ai_custom_commands = {
  commit = "=commit",
}

return M
