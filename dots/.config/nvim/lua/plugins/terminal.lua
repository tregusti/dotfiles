-- Toggleable shell terminal. Same snacks.nvim window machinery as the
-- Claude split (plugins/agent.lua), so the two toggles feel like one system.
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
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
    {
      '<leader>tt',
      -- show a picker with all running (but maybe hidden) terminals.
      function()
        local terms = require('snacks').terminal.list()
        if vim.tbl_isempty(terms) then
          vim.notify('No terminals open', vim.log.levels.INFO)
          return
        end
        vim.ui.select(terms, {
          prompt = 'Terminals',
          format_item = function(term)
            local meta = vim.b[term.buf].snacks_terminal or {}
            local title = vim.b[term.buf].term_title
            return string.format(
              '%s: %s (%s)',
              meta.id or '?',
              title or meta.cwd or '?',
              meta.cwd or '?'
            )
          end,
        }, function(choice)
          if choice then
            choice:show():focus()
          end
        end)
      end,
      desc = '[T]erminal picker',
    },
  },
}
