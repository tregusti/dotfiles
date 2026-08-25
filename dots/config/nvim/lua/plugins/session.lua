-- Session persistence: remember buffers/windows/tabs per directory and
-- restore them on demand.
--
-- Decision: manual restore via keymap, not auto-restore on launch -- matches
-- how the plugin's own author uses it (see github.com/folke/persistence.nvim
-- issue #13). Sessions are scoped to the directory only (branch = false):
-- separate repos in separate tabs already get separate sessions by cwd, and
-- branch-scoped sessions were a deliberate non-goal here.
--
-- The Claude Code terminal (agent.lua) is wiped from every saved session:
-- Snacks tags every terminal buffer with the same filetype, so the only way
-- to single it out is the command Snacks recorded on the buffer. Restoring
-- it is a fresh `claude --continue` via <leader>ac, not part of the session.
--
-- Docs: https://github.com/folke/persistence.nvim

--- @param cmd string|string[]|nil
--- @param needle string
local function cmd_contains(cmd, needle)
  if type(cmd) == 'string' then
    return cmd:find(needle, 1, true) ~= nil
  elseif type(cmd) == 'table' then
    for _, part in ipairs(cmd) do
      if tostring(part):find(needle, 1, true) then
        return true
      end
    end
  end
  return false
end

return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    branch = false,
  },
  config = function(_, opts)
    require('persistence').setup(opts)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceSavePre',
      group = vim.api.nvim_create_augroup('persistence-exclude-claude', { clear = true }),
      desc = 'Drop the Claude Code terminal before a session is saved',
      callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local term = vim.b[buf].snacks_terminal
          if term and cmd_contains(term.cmd, 'claude') then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end,
    })
  end,
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Restore [S]ession for cwd',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = "[D]on't save on exit",
    },
    { '<leader>qq', '<cmd>qa<CR>', desc = '[Q]uit all' },
  },
}
