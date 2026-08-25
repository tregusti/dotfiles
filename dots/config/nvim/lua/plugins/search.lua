-- grug-far.nvim, chosen over
--
-- - nvim-spectre (no undo support, mismatched rg/sed regex dialects)
-- - nvim-rip-substitute (one-shot commit, no per-match review)
-- - searchbox.nvim (no project-wide replace)
--
-- Config adopted from LazyVim.
return {
  {
    'MagicDuck/grug-far.nvim',
    opts = {
      headerMaxWidth = 80,
      keymaps = {
        -- close = { n = '<localleader>q' }, -- default: q is send to quicklist
      },
    },
    cmd = { 'GrugFar', 'GrugFarWithin' },
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require('grug-far')
          local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
              -- by default search hidden/dotfiles as well.
              flags = '--hidden',
            },
          })
        end,
        mode = { 'n', 'x' },
        desc = 'Search and Replace',
      },
    },
  },
}
