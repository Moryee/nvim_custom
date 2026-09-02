---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- Install diffview instead of fugitive
vim.pack.add { gh 'sindrets/diffview.nvim' }

local actions = require 'diffview.actions'

require('diffview').setup {
  keymaps = {
    file_panel = {
      { 'n', 'j', 'none', { desc = 'Bring the cursor to the next file entry' } },
      { 'n', 'k', actions.next_entry, { desc = 'Bring the cursor to the next file entry' } },
      { 'n', 'l', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' } },
      { 'n', 'o', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
      { 'n', ';', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
      { 'n', 'w', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
      { 'n', 'e', actions.select_entry, { desc = 'Open the diff for the selected entry' } },
    },
  },
}

-- Keymaps for Diffview
-- Opens the side-by-side diff workspace
vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>', { desc = '[G]it [D]iff' })

-- Closes the diff workspace and restores your windows exactly as they were
vim.keymap.set('n', '<leader>gx', ':DiffviewClose<CR>', { desc = 'Close Git Diff' })
