-- which-key: pop-up that shows what keys are available after you start a mapping.
--
-- Especially useful while relearning the leader key — press <leader> and pause, and
-- a menu shows every leader mapping. Pairs directly with the deferred keymap work.
--
-- PROVISIONAL (low-fluency, not yet formally chosen), but included now precisely
-- because it makes the teach-session leader practice easier.
--
-- Docs: https://github.com/folke/which-key.nvim

return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    delay = 300, -- ms to wait before the popup shows (matches 'timeoutlen').
    icons = {
      mappings = vim.g.have_nerd_font,
    },
    -- Group labels for the mnemonic prefixes used elsewhere in the config.
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>h', group = 'Git [H]unk' },
      { '<leader>a', group = '[A]gent (Claude Code)' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>t', group = '[T]erminal' },
    },
  },
}
