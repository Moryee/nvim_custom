-- Add plugins in this folder which are grouped as base plugins.
-- They are executed in specific order, and have some connection
-- between each other.

-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
require 'plugins.third_party.core.plugin_manager'


-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  -- [[ Installing and Configuring Plugins ]]
  --
  -- To install a plugin simply call `vim.pack.add` with its git url.
  -- This will download the default branch of the plugin, which will usually be `main` or `master`
  -- You can also have more advanced specs, which we will talk about later.
  --
  -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
  --
  -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
  -- automatically detecting and setting the indentation.
  --
  -- We first install it from https://github.com/NMAC427/guess-indent.nvim
  -- and then call its `setup()` function to start it with default settings.
  require 'plugins.third_party.core.guess_indent'

  -- Useful plugin to show you pending keybinds.
  require 'plugins.third_party.core.which_key'

  -- [[ Colorscheme ]]
  require 'plugins.third_party.core.colorscheme'

  -- Highlight todo, notes, etc in comments
  require 'plugins.third_party.core.todo_comments'

  -- [[ mini.nvim ]]
  require 'plugins.third_party.core.mini_nvim'
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
-- require 'plugins.third_party.core.telescope'
require 'plugins.third_party.core.fzf_lua'

-- ============================================================
-- SECTION 6: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
require 'plugins.third_party.core.lsp'

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
require 'plugins.third_party.core.formatter'


-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
require 'plugins.third_party.core.autocomplete_and_snippets'

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
require 'plugins.third_party.core.treesitter'
