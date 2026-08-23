do
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

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

  -- Normal, Visual, and Operator-pending modes
  -- map({ 'n', 'v', 'o' }, '<M-u>', '^', opts) -- Alt+u = Home (first non-blank character)
  -- map({ 'n', 'v', 'o' }, '<M-p>', '$', opts) -- Alt+p = End
  -- map({ 'n', 'v', 'o' }, '<M-i>', '<C-d>', opts) -- Alt+i = Page Down (half page)
  -- map({ 'n', 'v', 'o' }, '<M-o>', '<C-u>', opts) -- Alt+o = Page Up (half page)

  -- Insert mode (using standard Home/End/PgUp/PgDn behaviors)
  -- map('i', '<M-u>', '<Home>', opts)
  -- map('i', '<M-p>', '<End>', opts)
  -- map('i', '<M-i>', '<PageDown>', opts)
  -- map('i', '<M-o>', '<PageUp>', opts)
end
