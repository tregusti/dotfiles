-- Toggleable file explorer. Same snacks.nvim picker machinery as the
-- terminal/Claude toggles — Snacks.explorer.open() already toggles closed
-- if an explorer picker is open (see snacks/picker/init.lua: M.pick).
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
--
-- PROVISIONAL keymap — revisit with the rest of the keymap design.
return {
  'folke/snacks.nvim',
  opts = {
    -- General explorer module settings (only replace_netrw/trash live here —
    -- see plugins/explorer.lua discussion in teach/nvim lesson 9).
    explorer = {}, -- defaults: replace_netrw = true, trash = true
    -- Picker-level settings for the explorer source specifically.
    picker = {
      sources = {
        explorer = {
          hidden = true, -- always show dotfiles, no H toggle needed
          fuzzy = true,
        },
      },
    },
  },
  keys = {
    {
      '<C-e>',
      function()
        require('snacks').explorer.open()
      end,
      desc = 'Toggle file explorer',
    },
  },
}
