vim.keymap.set('n', '<leader>gu', '<cmd>DiffUnsaved<CR>', { desc = '[G]it diff [U]nsaved' })

vim.api.nvim_create_user_command('DiffUnsaved', function()
  local file = vim.fn.expand '%'
  if file == '' then return end

  local CR_SYM = '␍'
  local LF_SYM = '↵'

  local tmpfile_old = vim.fn.tempname()
  local tmpfile_new = vim.fn.tempname()

  -- 1. Read EXACT raw bytes from the saved disk file
  local f_old = io.open(file, 'rb')
  if not f_old then return end
  local old_content = f_old:read '*a'
  f_old:close()

  -- Replace \r and \n with our symbols, keeping actual \n so git doesn't break
  local formatted_old = old_content:gsub('\r', CR_SYM):gsub('\n', LF_SYM .. '\n')

  local out_old = io.open(tmpfile_old, 'wb')
  if out_old then
    out_old:write(formatted_old)
    out_old:close()
  end
  -- 2. Construct exactly what the RAM buffer WILL look like when saved
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local eol = vim.bo.fileformat == 'dos' and '\r\n' or '\n'
  local new_content = table.concat(lines, eol)

  -- Emulate Neovim's default behavior of adding a final newline to the file
  if vim.bo.eol or vim.bo.fixeol then new_content = new_content .. eol end

  local formatted_new = new_content:gsub('\r', CR_SYM):gsub('\n', LF_SYM .. '\n')

  local out_new = io.open(tmpfile_new, 'wb')
  if out_new then
    out_new:write(formatted_new)
    out_new:close()
  end
  -- 3. Open the side window
  vim.cmd 'vnew'
  local diff_buf = vim.api.nvim_get_current_buf()

  -- 4. Run git diff
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

  -- 5. Window configuration
  vim.bo[diff_buf].bufhidden = 'wipe'
  vim.bo[diff_buf].swapfile = false
  vim.keymap.set('n', 'q', '<cmd>q<CR>', { buffer = diff_buf, silent = true })
end, { desc = 'Show unsaved changes using colored git terminal diff (with strict line endings)' })

