-- Git: gitsigns (replaces the old vim-gitgutter).
--
-- Shows added/changed/removed lines in the sign column and offers hunk
-- staging/preview. Chosen over a heavier Git UI (neogit/fugitive) — terminal git +
-- gitsigns + Snacks.explorer's git-status covers it (see teach/nvim learning
-- record 0005).
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
      linehl = true,
      -- color the number column per change type (bg + fg; see colorscheme.lua).
      numhl = true,
      -- highlight the changed word itself, on the line (see colorscheme.lua).
      word_diff = true,
      -- border on the hunk-preview/blame popups, so they're visually
      -- distinct from the code behind them. :help gitsigns-config-preview_config
      preview_config = {
        border = 'rounded',
      },
      -- Keymaps: kickstart's ]c / [c hunk navigation + <leader>h* hunk ops.
      -- :help gitsigns-functions
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
        map('n', '<leader>hs', gs.stage_hunk, 'Git: (Un)[S]tage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Git: [R]eset hunk')
        map('n', '<leader>hb', gs.blame_line, 'Git: [B]lame line')
      end,
    },
  },
}
