---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'tpope/vim-fugitive' }

vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = '[G]it [C]ommit' })
