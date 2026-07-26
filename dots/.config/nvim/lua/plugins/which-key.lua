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
      { '<leader>a', group = '[A]gent (Claude Code)' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>h', group = 'Git [H]unk' },
      { '<leader>q', group = '[Q]uit/Session' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]erminal' },
      { '<leader>u', group = '[U]I' },
      { '<leader>x', group = 'E[x]tras' },
    },
  },
}
