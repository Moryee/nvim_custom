--[[
What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- TODO: add unused plugins discovery and logging it
-- into messages during launch.

-- Check LIGHT_MODE env argument
local is_light_mode = vim.env.LIGHT_MODE == '1'

-- Always load core and custom plugins
require 'plugins.custom.core'
require 'plugins.custom.remap_hjkl'
require 'plugins.custom.highlight_selection'

if not is_light_mode then
  require 'plugins.third_party.core'

  require 'plugins.third_party.indent_line'
  require 'plugins.third_party.lint'
  require 'plugins.third_party.autopairs'
  require 'plugins.third_party.neo_tree'
  require 'plugins.third_party.gitsigns'
  require 'plugins.third_party.diffview'
  -- require 'plugins.third_party.avante' -- TODO: remove later
  require 'plugins.third_party.codecompanion'

  -- NOTE: Cleanup command must be accesible always in the full
  -- access mode to prevent removal of plugins that are used, but
  -- not actually loaded.
  require 'plugins.custom.cmd_delete_unused_plugins'
end

require 'plugins.custom.cmd_copy_matches'
require 'plugins.custom.diff_custom'

-- The line beneath this is called `modeline`. See `:help modeline`
--u
-- vim: ts=2 sts=2 sw=2 et
