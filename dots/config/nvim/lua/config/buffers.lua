-- Buffer management. Not a plugin, so lives here rather than lua/plugins/
-- (same reasoning as window-dim.lua).

-- Delete current buffer. :help bdelete
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })

-- Bulk-close: review every buffer without unsaved changes in a checklist
-- (modified buffers are excluded entirely — never candidates for closing),
-- all preselected, <Tab>/<Space> to deselect ones to keep, <CR> to close the
-- rest. Tried building this on Telescope's buffers picker first; the
-- fuzzy-filter/insert-mode model was a poor fit for a "review and confirm"
-- checklist, so this is a plain floating window instead.

-- Each row also gets a direct toggle key (1-9, 0, a-z — 36 slots, same cap as
-- vim-bufclean). 'q' is part of that range, so cancel is <Esc>-only here.
local IDS = {}
for c = string.byte('1'), string.byte('9') do
  table.insert(IDS, string.char(c))
end
table.insert(IDS, '0')
for c = string.byte('a'), string.byte('z') do
  table.insert(IDS, string.char(c))
end

local function closable_buffers()
  local bufnrs = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(bufnr)
      and vim.bo[bufnr].buflisted
      and not vim.bo[bufnr].modified
    then
      table.insert(bufnrs, bufnr)
    end
  end
  return bufnrs
end

local function buffer_clean()
  local bufnrs = closable_buffers()
  if #bufnrs == 0 then
    vim.notify('No closable buffers', vim.log.levels.INFO)
    return
  end
  if #bufnrs > #IDS then
    vim.notify(
      string.format('Only showing the first %d closable buffers', #IDS),
      vim.log.levels.WARN
    )
    for i = #IDS + 1, #bufnrs do
      bufnrs[i] = nil
    end
  end

  local selected = {}
  for i in ipairs(bufnrs) do
    selected[i] = true
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'wipe'

  local HELP = {
    '',
    'id / <Tab> / <Space>  toggle',
    '<CR> close selected     <Esc> cancel',
  }

  local function render()
    local lines = {}
    for i, bufnr in ipairs(bufnrs) do
      local name = vim.api.nvim_buf_get_name(bufnr)
      name = name ~= '' and vim.fn.fnamemodify(name, ':~:.') or '[No Name]'
      lines[i] = string.format('%s %s %s', IDS[i], selected[i] and '[x]' or '[ ]', name)
    end
    for _, line in ipairs(HELP) do
      table.insert(lines, line)
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
  end

  render()

  local width = 60
  local height = #bufnrs + #HELP
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' Close buffers ',
    title_pos = 'center',
  })

  local function toggle_row(row)
    if row > #bufnrs then
      return
    end
    selected[row] = not selected[row]
    render()
    vim.api.nvim_win_set_cursor(win, { row, 0 })
  end

  local function toggle_current()
    toggle_row(vim.api.nvim_win_get_cursor(win)[1])
  end

  local function confirm()
    vim.api.nvim_win_close(win, true)
    for i, bufnr in ipairs(bufnrs) do
      if selected[i] then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
      end
    end
  end

  local function cancel()
    vim.api.nvim_win_close(win, true)
  end

  local opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set('n', '<Tab>', toggle_current, opts)
  vim.keymap.set('n', '<Space>', toggle_current, opts)
  vim.keymap.set('n', '<CR>', confirm, opts)
  vim.keymap.set('n', '<Esc>', cancel, opts)
  for i in ipairs(bufnrs) do
    vim.keymap.set('n', IDS[i], function()
      toggle_row(i)
    end, opts)
  end
end

vim.keymap.set('n', '<leader>bc', buffer_clean, { desc = '[B]uffer [C]lean' })
