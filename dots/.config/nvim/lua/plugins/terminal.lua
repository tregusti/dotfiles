-- Toggleable shell terminal. Same snacks.nvim window machinery as the
-- Claude split (plugins/agent.lua), so the two toggles feel like one system.
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
--
-- PROVISIONAL keymap — revisit with the rest of the keymap design.
return {
  'folke/snacks.nvim',
  keys = {
    {
      '<C-/>',
      function()
        require('snacks').terminal.toggle()
      end,
      mode = { 'n', 't' },
      desc = 'Toggle terminal',
    },
  },
}
