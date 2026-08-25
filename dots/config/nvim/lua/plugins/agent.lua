-- Claude Code companion.
--
-- Requires the `claude` CLI on PATH (installed separately; see README).
-- Docs: https://github.com/coder/claudecode.nvim
--
-- Per-project spellcheck language override. terminal_cmd is a plain string
-- fixed at startup (claudecode.nvim asserts this), so this only reacts to the
-- cwd Neovim was launched with, not later :cd calls.
--
-- Claude Code itself ignores `spellcheck` in any project settings file, so we
-- read it ourselves and re-inject it via `claude --settings`. This keeps which
-- projects use which language out of this (checked-in) config entirely — it
-- lives in each project's own .claude/settings.spellcheck.json instead, kept
-- separate from settings.local.json so it can be committed (it's just a
-- language choice, not personal permissions).
local function terminal_cmd()
  local settings_path = vim.fn.getcwd() .. '/.claude/settings.spellcheck.json'
  if vim.fn.filereadable(settings_path) == 0 then
    return 'claude --continue'
  end
  local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(settings_path), '\n'))
  if not ok or not decoded.spellcheck then
    return 'claude --continue'
  end
  return 'claude --continue --settings '
    .. vim.fn.shellescape(vim.json.encode({ spellcheck = decoded.spellcheck }))
end

return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' }, -- used for the terminal split UI.
  opts = {
    -- Resume the project's last conversation on launch instead of starting
    -- blank. Falls back to a new conversation when there is no history.
    -- Session picking is done inside Claude Code itself (/resume).
    terminal_cmd = terminal_cmd(),
    diff_opts = {
      open_in_new_tab = true,
      hide_terminal_in_new_tab = true,
    },
    terminal = {
      split_width_percentage = 0.40, -- wider than the 0.30 default.
      snacks_win_opts = {
        keys = {
          -- <leader>ac only works in Normal mode; inside the terminal every
          -- keystroke goes to the Claude process instead (Terminal mode), so
          -- give it a dedicated terminal-mode hide key too.
          claude_hide = {
            '<C-,>',
            function(self)
              self:hide()
            end,
            mode = 't',
            desc = 'Hide Claude',
          },
        },
      },
    },
  },
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code terminal' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude Code' },
    -- Same key as the Terminal-mode hide below, so <C-,> reads as one toggle
    -- even though it's two separate mappings in two different modes.
    { '<C-,>', '<cmd>ClaudeCodeFocus<cr>', mode = { 'n', 'x' }, desc = 'Focus Claude Code' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection to Claude' },
    -- Diff review of a proposed edit:
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept proposed diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny proposed diff' },
  },
}
