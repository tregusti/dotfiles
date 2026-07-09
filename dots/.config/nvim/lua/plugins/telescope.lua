-- Fuzzy finder: Telescope (replaces the old CtrlP).
--
-- Decision: docs/adr/ — Telescope for its documentation and ecosystem.
-- Docs: https://github.com/nvim-telescope/telescope.nvim
--
-- External deps (see README): ripgrep (live_grep) and fd (find_files). Both are
-- installed via Homebrew.
--
-- PROVISIONAL keymaps: the <leader>s* mnemonic scheme below is kickstart's. It's a
-- sensible default to start from, but the exact bindings are part of the deferred
-- keymap design — revisit after /teach vim.

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',            -- lua utility library Telescope depends on.
    {
      -- Native FZF sorter — much faster/​better fuzzy matching. Built with `make`.
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' }, -- route vim.ui.select through Telescope.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('telescope').setup({
      defaults = {
        file_ignore_patterns = { '%.git/' },
      },
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    })

    -- Load extensions (safe if not built). :help telescope.load_extension
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require('telescope.builtin')
    -- :help telescope.builtin for the full list of pickers.
    -- hidden = true: fd (Telescope's finder) excludes dotfiles by default.
    -- :help telescope.builtin.find_files
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files({ hidden = true })
    end, { desc = '[S]earch [F]iles' })
    -- no_ignore = true: fd (Telescope's finder) normally excludes gitignored files. Include them.
    vim.keymap.set('n', '<leader>si', function()
      builtin.find_files({ hidden = true, no_ignore = true })
    end, { desc = '[S]earch [I]gnored files' })

    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })
  end,
}
