-- Non-plugin key mappings.
--
-- Plugin-specific keymaps live next to each plugin (e.g. Telescope's are in
-- lua/plugins/telescope.lua) so they're documented where the feature is defined.
--
-- `vim.keymap.set(mode, lhs, rhs, opts)` — :help vim.keymap.set

-- Exit insert mode with 'jk' (long-standing muscle memory). :help :inoremap
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Clear search highlight with <Esc> in normal mode. :help :nohlsearch
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- <leader>xl / <leader>xq (loclist/quickfix toggles) and <leader>uw (wrap
-- toggle) live in plugins/ui-toggles.lua, not here — they're built on
-- Snacks.toggle, and this file loads before lazy.nvim sets up plugins
-- (see init.lua), so `require('snacks')` isn't resolvable yet at this point.

-- Move between windows with <C-h/j/k/l> (kept from the old config — this one is
-- reflex, not something to relearn). :help CTRL-W_h
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Go to right window' })

-- Same <C-h/j/k/l> reflex from inside a terminal: leave Terminal mode,
-- then move. Terminal-mode keys otherwise go to the running program —
-- the same reason the Claude split needed its own hide key. :help terminal-input
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Go to right window' })

-- Highlight text briefly when yanked — nice visual feedback. :help vim.highlight.on_yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Vim only checks for external file changes on specific triggers, not continuously
-- — prompt that check here so `autoread` (options.lua) actually kicks in. :help :checktime
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Check if the current file changed on disk',
  group = vim.api.nvim_create_augroup('checktime', { clear = true }),
  command = 'checktime',
})
