-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })
vim.keymap.set('n', '|', '<Cmd>Neotree buffers<CR>', { desc = 'NeoTree buffers', silent = true })
vim.keymap.set('n', '<leader>gs', '<cmd>Neotree git_status<CR>', { desc = '[G]it [S]tatus' })

require('neo-tree').setup {
  window = {
    mappings = {
      ['\\'] = 'close_window',
      ['w'] = 'toggle_node',
      -- ['<space>'] = 'open',
      ['<space>'] = 'open_nofocus',
    },
  },
  commands = {
    open_nofocus = function(state)
      -- Save the current Neo-tree window ID
      local neo_tree_win = vim.api.nvim_get_current_win()
      -- Run the default open action
      state.commands.open(state)
      -- Instantly put the cursor back into the Neo-tree window
      vim.api.nvim_set_current_win(neo_tree_win)
    end,
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false, -- Optional: also show files ignored by git
    },
  },
}
