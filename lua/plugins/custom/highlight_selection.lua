-- TODO: restrict search to currently visible text
vim.api.nvim_create_augroup('VisualSelectionHighlight', { clear = true })

vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged' }, {
  group = 'VisualSelectionHighlight',
  callback = function()
    -- 1. Always clear the previous highlight in the CURRENT window
    if vim.w.v_match_id then
      pcall(vim.fn.matchdelete, vim.w.v_match_id)
      vim.w.v_match_id = nil
    end

    -- 2. Check if we are currently in visual mode
    local mode = vim.api.nvim_get_mode().mode
    if mode:sub(1, 1) ~= 'v' and mode:sub(1, 1) ~= 'V' and mode ~= '\22' then return end

    -- 3. Get the start and end of the visual selection
    local v_start = vim.fn.getpos('v')
    local v_end = vim.fn.getpos('.')

    -- Only run for single-line selections to keep performance fast
    if v_start[2] ~= v_end[2] then return end

    local start_col = math.min(v_start[3], v_end[3])
    local end_col = math.max(v_start[3], v_end[3])

    -- 4. Extract the highlighted text
    local line = vim.api.nvim_buf_get_lines(0, v_start[2] - 1, v_start[2], false)[1]
    if not line then return end

    local text = string.sub(line, start_col, end_col)

    -- Ignore empty strings or single characters (prevents screen flashing)
    if #text < 2 then return end

    -- 5. Escape the text and highlight it using \V (literal text match)
    text = vim.fn.escape(text, '\\')
    -- Store the ID in the window (vim.w) so splits don't break it
    -- vim.w.v_match_id = vim.fn.matchadd('IlluminatedWordRead', '\\V' .. text)
    vim.w.v_match_id = vim.fn.matchadd('VisualSelectionMatch', '\\V' .. text)
  end,
})
