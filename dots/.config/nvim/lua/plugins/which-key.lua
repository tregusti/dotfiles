-- which-key: pop-up that shows what keys are available after you start a mapping.
--
-- Press <leader> and pause, and a menu shows every leader mapping.
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
