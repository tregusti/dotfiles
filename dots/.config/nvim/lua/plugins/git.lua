-- Git: gitsigns (replaces the old vim-gitgutter).
--
-- PROVISIONAL (low-fluency, not yet formally chosen): gitsigns shows added/changed/
-- removed lines in the sign column and offers hunk staging/preview. A heavier Git UI
-- (neogit / fugitive) was left open as a separate decision. This covers the gutter
-- + basic hunk ops the old config had.
--
-- Docs: https://github.com/lewis6991/gitsigns.nvim

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- Gutter signs for each change type. :help gitsigns-config-signs
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      -- background color on the full changed line (falls back to DiffAdd/
      -- DiffChange/DiffDelete, which Solarized already defines with a bg).
      linehl = true,
      -- highlight actual diff on line
      word_diff = true,
      -- PROVISIONAL keymaps (kickstart's ]c / [c hunk navigation + <leader>h* hunk
      -- ops) — revisit after /teach vim. :help gitsigns-functions
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map('n', ']c', function()
          gs.nav_hunk('next')
        end, 'Next git hunk')
        map('n', '[c', function()
          gs.nav_hunk('prev')
        end, 'Previous git hunk')
        map('n', '<leader>hp', gs.preview_hunk, 'Git: [P]review hunk')
        map('n', '<leader>hs', gs.stage_hunk, 'Git: [S]tage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Git: [R]eset hunk')
        map('n', '<leader>hb', gs.blame_line, 'Git: [B]lame line')
      end,
    },
  },
}
