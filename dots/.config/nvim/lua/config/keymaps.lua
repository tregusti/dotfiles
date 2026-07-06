-- Non-plugin key mappings.
--
-- PROVISIONAL. Keymaps and leader-key ergonomics are being deliberately deferred
-- until after the Vim `/teach` session (the owner is relearning the leader key and
-- motions). This file intentionally holds only a minimal, safe, uncontroversial
-- set. The bigger leader-driven map is designed later, with fluency.
--
-- Plugin-specific keymaps live next to each plugin (e.g. Telescope's are in
-- lua/plugins/telescope.lua) so they're documented where the feature is defined.
--
-- `vim.keymap.set(mode, lhs, rhs, opts)` — :help vim.keymap.set

-- Exit insert mode with 'jk' (long-standing muscle memory). :help :inoremap
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Clear search highlight with <Esc> in normal mode. :help :nohlsearch
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Diagnostics: open the location list of problems in the buffer. :help vim.diagnostic.setloclist
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Move between windows with <C-h/j/k/l> (kept from the old config — this one is
-- reflex, not something to relearn). :help CTRL-W_h
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Go to right window' })

-- Highlight text briefly when yanked — nice visual feedback. :help vim.highlight.on_yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
