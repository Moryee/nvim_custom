local add_dependency = require('utils.add_dependency').add_dependency
local constants = require 'constants'

-- Add dependencies safely
add_dependency('plenary', { 'https://www.github.com/nvim-lua/plenary.nvim' })
add_dependency('nvim-treesitter', { 'https://github.com/nvim-treesitter/nvim-treesitter' })

-- Add and setup CodeCompanion
add_dependency('codecompanion', { {
  src = 'https://www.github.com/olimorris/codecompanion.nvim',
  version = vim.version.range '^19.0.0',
} })

require('codecompanion').setup {
  interactions = {
    chat = {
      adapter = 'openrouter',
      sessions = {
        enabled = true,
        autosave = true,
        continuous_save = true,
        save_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "codecompanion", "sessions"),
      },
    },
    inline = { adapter = 'openrouter' },
    agent = { adapter = 'openrouter' },
  },

  adapters = {
    http = {
      openrouter = function()
        return require('codecompanion.adapters').extend('openrouter', {
          env = {
            url = 'https://openrouter.ai/api',
            api_key = 'OPENROUTER_API_KEY',
            chat_url = '/v1/chat/completions',
          },
          schema = {
            -- model = { default = "anthropic/claude-sonnet-4.5" },
            model = { default = '@preset/coding-preset' },
            -- preset = { default = 'coding-preset' },
          },
        })
      end,
    },
  },
  rules = {
    no_rules = {
      description = 'Collection of common files for all projects',
      files = {},
      is_preset = true,
    },
    opts = {
      chat = {
        autoload = 'no_rules',
        enabled = true,
      },
    },
  },

  prompt_library = {
    ['[cstm] Generate Commit'] = {
      strategy = 'chat',
      interation = 'chat',
      description = '[cstm] Generate a commit message using custom rules and staged git diff',
      opts = {
        alias = 'cstm_commit',
        auto_submit = false,
        ignore_system_prompt = true,
        -- is_slash_cmd = 'true'
      },
      -- TODO: add context https://codecompanion.olimorris.dev/configuration/prompt-library#context-placeholders
      prompts = {
        {
          role = 'system',
          content = function()
            -- Reads your custom commit prompt dynamically
            local file = io.open(constants.ai_custom_prompts.commit_message, 'r')
            if file then
              local content = file:read '*a'
              file:close()
              return content
            end
            return 'You are an expert at writing conventional commit messages.'
          end,
        },
        {
          role = 'user',
          content = function()
            -- Automatically grabs your staged git diff
            local diff = vim.fn.system 'git diff --staged'
            if diff == '' then return 'There are no staged changes. Please stage files first.' end

            -- TODO: grab last 10 commits with full commit messages
            local log_cmd = 'git log -n 5 --oneline 2>/dev/null'
            local logs = vim.fn.system(log_cmd)

            local log_context = ''
            -- Only append logs if they exist and the command succeeded (handles brand new repos)
            if vim.v.shell_error == 0 and logs ~= '' then log_context = 'Here are the last commit messages for context:\n```text\n' .. logs .. '```\n\n' end

            return log_context .. 'Please generate a commit message for the following staged changes:\n\n```diff\n' .. diff .. '\n```'
          end,
        },
      },
    },
    ['[cstm] Generate Tests'] = {
      strategy = 'chat',
      interaction = 'chat',
      description = '[cstm] Generate unit tests (manual input)',
      opts = {
        alias = 'cstm_tests',
        auto_submit = false, -- Important: Set to false so you can type before it sends
        ignore_system_prompt = true,
      },
      prompts = {
        {
          role = 'system',
          content = function()
            local file = io.open(constants.ai_custom_prompts.unit_tests, 'r')
            if file then
              local content = file:read '*a'
              file:close()
              return content
            end
            return 'Generate unit tests for the provided code.'
          end,
        },
        {
          role = 'user',
          content = 'Code to test:\n\nExample:\n',
        },
      },
    },
    -- TODO: add branch summary and pull request review
  },
}

-- Normal mode mappings
vim.keymap.set('n', '<Leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Toggle AI Chat' })
vim.keymap.set('n', '<Leader>ap', '<cmd>CodeCompanionActions<cr>', { desc = 'AI Prompt Library / Actions' })
vim.keymap.set('n', '<Leader>ac', '<cmd>CodeCompanion /cstm_commit<cr>', { desc = 'AI Generate Commit' })
vim.keymap.set('n', '<Leader>at', '<cmd>CodeCompanion /cstm_tests<cr>', { desc = 'AI Generate Unit Tests' })
vim.keymap.set('n', '<Leader>ai', '<cmd>CodeCompanion<cr>', { desc = 'AI Inline Prompt' })

-- Visual mode mappings
vim.keymap.set('v', '<Leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Toggle AI Chat' })
vim.keymap.set('v', '<Leader>ai', '<cmd>CodeCompanion<cr>', { desc = 'AI Inline Prompt (Selection)' })
vim.keymap.set('v', '<Leader>ad', '<cmd>CodeCompanionChat Add<cr>', { desc = 'AI Add Selection to Chat' })
