return {
  'christoomey/vim-tmux-navigator',
  -- Required whenever custom `keys` are supplied below (per the plugin's own
  -- README) — without it, the plugin's bundled script *also* installs its
  -- own default mappings in every mode, including terminal-mode, which is
  -- what caused literal ":TmuxNavigateLeft"-style text to land in a nested
  -- terminal buffer's input instead of navigating. See
  -- teach/tmux/NOTES.md's "Corrections" section (2026-08-18).
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
  end,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  -- The plugin README's own example includes a stray <C-U> here
  -- (leftover from the classic `:<C-U>Command<CR>` idiom for clearing a
  -- real command-line, which a <Cmd> mapping never opens) — it broke every
  -- press with "E492: Not an editor command: ^UTmuxNavigateLeft". Dropped
  -- below. See teach/tmux/NOTES.md's "Corrections" section (2026-08-18).
  keys = {
    { '<c-h>', '<cmd>TmuxNavigateLeft<cr>' },
    { '<c-j>', '<cmd>TmuxNavigateDown<cr>' },
    { '<c-k>', '<cmd>TmuxNavigateUp<cr>' },
    { '<c-l>', '<cmd>TmuxNavigateRight<cr>' },
    { '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>' },
  },
}
