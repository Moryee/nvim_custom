-- Helper function to replace line endings with visible symbols
local function format_line_endings(content)
  local CR_SYM = '␍'
  local LF_SYM = '↵'
  return content:gsub('\r', CR_SYM):gsub('\n', LF_SYM .. '\n')
end

-- Reusable diff function
-- @param target: string - Either 'disk' or 'index'
local function diff_buffer_against(target)
  local file = vim.fn.expand('%')
  if file == '' then
    vim.notify("No file associated with buffer", vim.log.levels.WARN)
    return
  end

  -- 1. Get the OLD content based on the target
  local old_content = ""
  if target == 'disk' then
    local f_old = io.open(file, 'rb')
    if not f_old then
      vim.notify("Could not read file from disk", vim.log.levels.ERROR)
      return
    end
    old_content = f_old:read('*a')
    f_old:close()
  elseif target == 'index' then
    -- Using ':./' tells git to find the file relative to the current working directory
    old_content = vim.fn.system({ 'git', 'show', ':./' .. file })
    if vim.v.shell_error ~= 0 then
      vim.notify("File not found in git index (is it tracked?)", vim.log.levels.WARN)
      return
    end
  end

  -- 2. Get the NEW content (What the RAM buffer WILL look like when saved)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local eol = vim.bo.fileformat == 'dos' and '\r\n' or '\n'
  local new_content = table.concat(lines, eol)

  -- Emulate Neovim's default behavior of adding a final newline
  if vim.bo.eol or vim.bo.fixeol then
    new_content = new_content .. eol
  end

  -- 3. Write formatted contents to temporary files
  local tmpfile_old = vim.fn.tempname()
  local tmpfile_new = vim.fn.tempname()

  local out_old = io.open(tmpfile_old, 'wb')
  if out_old then
    out_old:write(format_line_endings(old_content))
    out_old:close()
  end

  local out_new = io.open(tmpfile_new, 'wb')
  if out_new then
    out_new:write(format_line_endings(new_content))
    out_new:close()
  end

  -- 4. Open the side window
  vim.cmd('vnew')
  local diff_buf = vim.api.nvim_get_current_buf()

  -- 5. Run git diff
  local cmd = {
    'git',
    '--no-pager',
    'diff',
    '--color=always',
    '--word-diff=plain',
    '--word-diff-regex=[[:alnum:]]+|[^[:alnum:]]',
    '--no-index',
    tmpfile_old,
    tmpfile_new,
  }

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function()
      -- Clean up BOTH temporary files
      vim.fn.delete(tmpfile_old)
      vim.fn.delete(tmpfile_new)
    end,
  })

  -- 6. Window configuration
  vim.bo[diff_buf].bufhidden = 'wipe'
  vim.bo[diff_buf].swapfile = false
  vim.keymap.set('n', 'q', '<cmd>q<CR>', { buffer = diff_buf, silent = true })
end

-- ==========================================
-- Create Commands and Keymaps
-- ==========================================

vim.api.nvim_create_user_command('DiffUnsaved', function()
  diff_buffer_against('disk')
end, { desc = 'Diff buffer against saved file on disk' })

vim.api.nvim_create_user_command('DiffIndex', function()
  diff_buffer_against('index')
end, { desc = 'Diff buffer against git index (staged)' })

vim.keymap.set('n', '<leader>gu', '<cmd>DiffUnsaved<CR>', { desc = '[G]it diff [U]nsaved (disk)' })
vim.keymap.set('n', '<leader>gU', '<cmd>DiffIndex<CR>', { desc = '[G]it diff [D]isk/Index' })


