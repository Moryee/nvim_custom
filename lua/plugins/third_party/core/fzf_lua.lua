local function gh(repo) return 'https://github.com/' .. repo end

do
  local fzf_plugins = {
    gh 'ibhagwan/fzf-lua',
    -- Optional but recommended for file icons
    gh 'nvim-tree/nvim-web-devicons',
  }

  vim.pack.add(fzf_plugins)

  local fzf = require('fzf-lua')

  fzf.setup {
    -- fzf-lua automatically registers itself as vim.ui.select,
    -- so no extra extension is needed!
    keymap = {
      -- These map to neovim's UI when not inside the terminal fzf
      builtin = {
        ['<M-k>'] = 'down',
        ['<M-l>'] = 'up',
        ['<C-u>'] = 'preview-page-up',
        ['<C-d>'] = 'preview-page-down',
      },
      -- These map directly to the fzf binary flags (--bind)
      fzf = {
        ['alt-k'] = 'down',
        ['alt-l'] = 'up',
        ['alt-j'] = 'preview-page-up',
        ['alt-;'] = 'preview-page-down',
      },
    },
    winopts = {
      fullscreen = true,
    },
    oldfiles = {
      include_current_session = true
    }
  }

  vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })

  -- Find files with hidden files shown, but hiding .git
  vim.keymap.set('n', '<leader>sf', function()
    fzf.files { fd_opts = "--color=never --type f --hidden --follow --exclude .git" }
  end, { desc = '[S]earch [F]iles' })

  vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })

  -- Smart handling for grep word (Normal) vs grep visual selection (Visual)
  vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('v', '<leader>sw', fzf.grep_visual, { desc = '[S]earch current [W]ord' })

  vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sR', fzf.resume, { desc = '[S]earch [R]esume' })

  -- Recent files (only in cwd)
  vim.keymap.set('n', '<leader>sr', function()
    fzf.oldfiles { cwd_only = true }
  end, { desc = '[S]earch [R]ecent files in current project' })
  -- vim.keymap.set('n', '<leader>sr', fzf.history, { desc = '[S]earch Recent Files ("." for repeat)' })


  vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = '[ ] Find existing buffers' })

  -- LSP Attach auto-command
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('fzf-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      vim.keymap.set('n', 'grr', fzf.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gri', fzf.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', 'grd', fzf.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      vim.keymap.set('n', 'gW', fzf.lsp_live_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
      vim.keymap.set('n', 'grt', fzf.lsp_typedefs, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })

  -- Fuzzily search current buffer (Replaces current_buffer_fuzzy_find)
  vim.keymap.set('n', '<leader>/', function()
    fzf.blines { winopts = { preview = { hidden = 'hidden' } } }
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- Grep across open files (fzf.lines acts across all loaded buffers)
  vim.keymap.set('n', '<leader>s/', fzf.lines, { desc = '[S]earch [/] in Open Files' })

  -- Search Neovim config files
  vim.keymap.set('n', '<leader>sn', function()
    fzf.files { cwd = vim.fn.stdpath('config') }
  end, { desc = '[S]earch [N]eovim files' })
end
