-- Snacks picker, explorer, and UI toggles.
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

return {
  'folke/snacks.nvim',
  -- Only fragment with opts/config for this plugin — keeps setup() single-owner.
  opts = {
    explorer = {}, -- defaults: replace_netrw = true, trash = true
    picker = {
      sources = {
        explorer = {
          hidden = true,
          focus = 'list',
          matcher = { fuzzy = true },
        },
      },
    },
  },
  config = function(_, opts)
    local Snacks = require('snacks')

    Snacks.setup(opts)

    Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')

    Snacks.toggle
      .new({
        name = 'Location List',
        get = function()
          return vim.fn.getloclist(0, { winid = 0 }).winid ~= 0
        end,
        set = function(state)
          if state then
            vim.diagnostic.setloclist()
          else
            vim.cmd('lclose')
          end
        end,
      })
      :map('<leader>xl')

    Snacks.toggle
      .new({
        name = 'Quickfix List',
        get = function()
          return vim.fn.getqflist({ winid = 0 }).winid ~= 0
        end,
        set = function(state)
          vim.cmd(state and 'copen' or 'cclose')
        end,
      })
      :map('<leader>xq')
  end,
  -- stylua: ignore
  keys = {
    -- file explorer

    -- top pickers
    { '<leader><leader>', function() Snacks.picker.smart() end, desc = 'Smart find files', },
    { '<leader>e', function() Snacks.explorer.open() end, desc = 'Toggle file explorer', },
    { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>/', function() Snacks.picker.grep({ hidden = true }) end, desc = 'Grep' },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>n', function() Snacks.picker.notifications() end, desc = 'Notification History' },
    -- search
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
    { '<leader>sg', function() Snacks.picker.grep({ hidden = true }) end, desc = '[S]earch by [G]rep', },
    { '<leader>sw', function() Snacks.picker.grep_word({ hidden = true }) end, desc = '[S]earch current [W]ord', },
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp', },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics', },
    -- git
    { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
    { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Line' },
    { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
    { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
    { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
    { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },
 },
}
