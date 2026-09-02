vim.api.nvim_create_user_command('CopyMatches', function()
  local pattern = vim.fn.getreg('/')
  if pattern == '' then return end

  local matches = {}
  local line_count = vim.fn.line('$')

  -- Loop through every line in the file
  for lnum = 1, line_count do
    local line = vim.fn.getline(lnum)
    local start_idx = 0

    -- Find all matches on the current line
    while true do
      local match = vim.fn.matchstr(line, pattern, start_idx)
      if match == '' then break end

      table.insert(matches, match)

      -- Move the search index forward to find the next match on the same line
      start_idx = vim.fn.matchend(line, pattern, start_idx)
      if start_idx == -1 then break end
    end
  end

  if #matches > 0 then
    vim.fn.setreg('+', table.concat(matches, "\n"))
    print("Copied " .. #matches .. " matches to clipboard!")
  else
    print("No matches found!")
  end
end, { desc = 'Copy all search matches to clipboard safely' })
