local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basic movement
map({ 'n', 'v', 'o' }, 'j', 'h', opts) -- Left
map({ 'n', 'v', 'o' }, 'k', 'j', opts) -- Down
map({ 'n', 'v', 'o' }, 'l', 'k', opts) -- Up
map({ 'n', 'v', 'o' }, ';', 'l', opts) -- Right

-- Remap 'h' to the old ';' (repeat find)
map({ 'n', 'v', 'o' }, 'h', ';', opts)

-- Normal, Visual, and Operator-pending modes
map({ 'n', 'v', 'o' }, '<M-j>', 'h', opts) -- Alt + j = Left
map({ 'n', 'v', 'o' }, '<M-k>', 'j', opts) -- Alt + k = Down
map({ 'n', 'v', 'o' }, '<M-l>', 'k', opts) -- Alt + l = Up
map({ 'n', 'v', 'o' }, '<M-;>', 'l', opts) -- Alt + ; = Right

-- Make them work in Insert mode so you don't have to reach for arrow keys!
map('i', '<M-j>', '<Left>', opts)
map('i', '<M-k>', '<Down>', opts)
map('i', '<M-l>', '<Up>', opts)
map('i', '<M-;>', '<Right>', opts)
