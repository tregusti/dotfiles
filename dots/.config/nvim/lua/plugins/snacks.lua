-- Fuzzy finder: Snacks picker (replaces telescope.nvim).
--
-- Same <leader>s* mnemonic scheme telescope.lua used to carry (kickstart's).
-- <leader><leader> is the one behavior change: it now opens the "smart"
-- picker (files + buffers + recent, frecency-ranked, hidden/ignored
-- live-togglable with <a-h>/<a-i>) instead of a plain buffer list — since
-- smart's file search already covers <leader>sf/<leader>si's scope, this
-- is the fast "just get me to a file" entry point.
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
return {
  'folke/snacks.nvim',
  keys = {
    { '<leader><leader>', function() require('snacks').picker.smart() end, desc = 'Smart find files' },

    -- hidden = true: match telescope.lua's old default of always showing dotfiles.
    { '<leader>sf', function() require('snacks').picker.files({ hidden = true }) end, desc = '[S]earch [F]iles' },
    -- ignored = true: also include gitignored files (fd's --no-ignore equivalent).
    {
      '<leader>si',
      function()
        require('snacks').picker.files({ hidden = true, ignored = true })
      end,
      desc = '[S]earch [I]gnored files',
    },
    { '<leader>sg', function() require('snacks').picker.grep({ hidden = true }) end, desc = '[S]earch by [G]rep' },
    {
      '<leader>sw',
      function()
        require('snacks').picker.grep_word({ hidden = true })
      end,
      desc = '[S]earch current [W]ord',
    },
    { '<leader>sh', function() require('snacks').picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sd', function() require('snacks').picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', function() require('snacks').picker.resume() end, desc = '[S]earch [R]esume' },
  },
}
