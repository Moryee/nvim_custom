---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- Highlight todo, notes, etc in comments
vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }
