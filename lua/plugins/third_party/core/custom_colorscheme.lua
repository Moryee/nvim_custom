---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'tjdevries/colorbuddy.nvim' }

require("colorbuddy").colorscheme('custom_colorscheme')

local colorbuddy = require('colorbuddy')
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
-- local g = colorbuddy.groups
local s = colorbuddy.styles

-- TODO:
-- - Make all builtin italic
-- - builtin constant (python's __name__)
-- - group them

-- Command ":Inspect" to see color group

-- Citylights colorscheme
-- # black
-- color0                    #1d252c
-- color8                    #566c7d
--
-- # red
-- color1                    #d95468
-- color9                    #d95468
--
-- # green
-- color2                    #8bd49c
-- color10                   #8bd49c
--
-- # yellow
-- color3                    #ebbf83
-- color11                   #ebbf83
--
-- # blue
-- color4                    #5ec4ff
-- color12                   #5ec4ff
--
-- # magenta
-- color5                    #c06ece
-- color13                   #c06ece
--
-- # cyan
-- color6                    #008b94
-- color14                   #70e1e8
--
-- # white
-- color7                    #a0b3c5
-- color15                   #a0b3c5
-- ==========================================
-- 1. PALETTE
-- ==========================================
-- Base Background & Foreground
Color.new('bg',        '#1d252c') -- color0  (black)
Color.new('gray',      '#566c7d') -- color8  (bright black)
Color.new('fg',        '#a0b3c5') -- color7  (white)
Color.new('white',      '#ffffff') -- color7  (white)

-- Accents
Color.new('red',       '#d95468') -- color1
Color.new('green',     '#8bd49c') -- color2
Color.new('yellow',    '#ebbf83') -- color3
Color.new('blue',      '#5ec4ff') -- color4
Color.new('magenta',   '#c06ece') -- color5
Color.new('cyan_dark', '#008b94') -- color6
Color.new('cyan',      '#70e1e8') -- color14 (bright cyan)

local colors = {
  c_type = c.green,
  c_function = c.yellow,
  c_variable = c.cyan:light(),
  c_constant = c.cyan_dark:light(),
  c_special_keywords = c.magenta,
  c_highlight = c.bg:light(),
  -- Other
  c_number = c.fg,
  c_string = c.blue:dark():dark(),
}
-- ==========================================
-- 2. EDITOR UI HIGHLIGHTS
-- ==========================================
-- Group.new('Normal', c.fg, c.bg)
Group.new('Normal', c.white, c.bg)
Group.new('LineNr', c.gray, c.none)
Group.new('CursorLine', c.none, colors.c_highlight)
Group.new('CursorLineNr', c.yellow, colors.c_highlight, s.bold)
Group.new('Visual', c.none, colors.c_highlight)

-- Splits and Borders
Group.new('VertSplit', c.gray:dark(), c.bg)
Group.new('FloatBorder', c.gray, c.bg)
Group.new('NormalFloat', c.fg, c.bg:dark())

-- Search and Match
Group.new('Search', c.bg, c.cyan:light())
Group.new('IncSearch', c.bg, c.yellow)

-- ==========================================
-- 3. SYNTAX HIGHLIGHTING (Standard & Treesitter)
-- ==========================================

-- Special keywords
Group.new('Comment', c.gray, c.none, s.italic)
Group.new('String', c.blue:dark():dark(), c.none)
-- Group.new('String', c.red:light(), c.none)
Group.new('Number', colors.c_number)
Group.new('Boolean', colors.c_special_keywords:light(), c.none)
Group.new('Keyword', colors.c_special_keywords)              -- e.g., 'local', 'return', 'function'
Group.new('Conditional', colors.c_special_keywords)          -- e.g., 'if', 'else'
Group.new('Repeat', colors.c_special_keywords)               -- e.g., 'for', 'while'

-- Functions
Group.new('Function', colors.c_function, c.none)
Group.new('@function.builtin', colors.c_function:dark(), c.none, s.italic)


-- Types, modules
Group.new('Type', colors.c_type)                 -- Classes, Structs, standard types
Group.new('@tag', colors.c_type)                 -- TSX tag
Group.new('@constructor', colors.c_type)  -- constructor = class call
Group.new('@type.builtin', colors.c_type:dark(), c.none, s.italic)
Group.new('@module', colors.c_type:dark())

-- Variables
local variable_color = c.cyan:light()
Group.new('@variable', c.cyan:light())
Group.new('@variable.builtin', c.cyan:dark(), c.none, s.italic)
-- local identifier_color = c.cyan:dark()
local identifier_color = c.blue
Group.new('@tag.attribute', identifier_color) -- TSX tag.attribute
Group.new('Identifier', identifier_color)
Group.new('@variable.member', identifier_color)
Group.new('Property', c.fg)
Group.new('Operator', c.fg)           -- +, -, =, ==
Group.new('Delimiter', c.fg)           -- +, -, =, ==
Group.new('Statement', c.magenta)

-- Decorators
Group.new('Constant', colors.c_constant, c.none)
Group.new('@constant', colors.c_constant, c.none)
Group.new('@constant.builtin', colors.c_constant, c.none, s.italic)

-- Special cases
Group.new('Whitespace', c.gray)
Group.new('NonText', c.gray)
Group.new('Special', c.magenta, c.none, s.italic)
Group.new('SpecialChar', c.red:light(), c.none)

-- Other

Group.new('@attribute', c.magenta, c.none)
Group.new('@attribute.builtin', c.magenta:dark(), c.none, s.italic)
-- ==========================================
-- 4. DIAGNOSTICS (LSP)
-- ==========================================
Group.new('DiagnosticError', c.red)
Group.new('DiagnosticWarn', c.yellow)
Group.new('DiagnosticInfo', c.blue)
Group.new('DiagnosticHint', c.cyan)

Group.new('DiagnosticUnderlineError', c.none, c.none, s.undercurl, c.red)
Group.new('DiagnosticUnderlineWarn', c.none, c.none, s.undercurl, c.yellow)

Group.new('LspReferenceWrite', c.bg, c.yellow)
Group.new('LspReferenceRead', c.none, colors.c_highlight:light())
Group.new('LspReferenceText', c.none, colors.c_highlight:light())
Group.new('VisualSelectionMatch', c.none, colors.c_highlight)

-- ==========================================
-- 5. Neotree plugin
-- ==========================================
Group.new('Directory', c.blue, c.none)
Group.new('NeoTreeFileName', c.fg, c.none)
-- Group.new('NeoTreeGitUntracked', c.red:light():light(), c.none)
Group.new('NeoTreeGitUntracked', c.white, c.none)
Group.new('Changed', c.yellow, c.none)
Group.new('Added', c.green, c.none)


-- ==========================================
-- 6. MATCHING PARENTHESES
-- ==========================================
-- When your cursor is on a bracket, this highlights the matching one
Group.new('MatchParen', c.yellow, c.gray:dark(), s.bold)

-- ==========================================
-- 7. STATUS BAR
-- ==========================================
-- Standard Neovim status bar at the bottom
-- Group.new('StatusLine', c.white, c.gray:dark())       -- Status bar for the active window
-- Group.new('StatusLineNC', c.white, c.bg:dark())        -- Status bar for inactive windows
Group.new('StatusLine', c.white, c.gray:dark())       -- Status bar for the active window
Group.new('StatusLineNC', c.fg, c.gray:dark():dark())

-- Note: If you are using a statusline plugin like `lualine.nvim`, 
-- you may need to set your lualine theme to "auto" or configure 
-- its colors specifically within the lualine setup function.
--
--
-- -- Floating Windows (WhichKey, LSP Hover, etc.)
-- Group.new('NormalFloat', c.fg, c.bg:light())   -- The background of floating windows
Group.new('NormalFloat', c.fg, c.gray:dark():dark())   -- The background of floating windows
Group.new('FloatBorder', c.gray, c.bg:light()) -- The border of floating windows

-- Popup Menus (Autocomplete dropdowns like nvim-cmp)
Group.new('Pmenu', c.fg, c.bg:light())         -- Autocomplete menu background
Group.new('PmenuSel', c.bg, c.blue)            -- The selected item in the autocomplete menu
Group.new('PmenuThumb', c.none, c.gray)        -- The scrollbar thumb

Group.new('IblScope', c.cyan_dark)                    -- The active context/scope line (ibl v3)
--
-- Group.new('TreesitterContext', c.none, c.bg:light(), s.bold)                 -- Background of the sticky line
-- Group.new('TreesitterContextBottom', c.none, c.none, s.underline)    -- Separator line underneath it
-- Group.new('TreesitterContextLineNumber', c.gray, c.bg:light())
--
--

