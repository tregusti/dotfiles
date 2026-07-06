-- Claude Code companion.
--
-- Decision: docs/adr/0003 — terminal workflow + a companion plugin that speaks
-- Claude Code's IDE-integration protocol (the same WebSocket protocol the VS Code /
-- JetBrains extensions use). Proposed edits open as native Neovim diff splits to
-- accept/reject, and the current selection/buffer is shared as context. The agent
-- reads/writes files and shows diffs — it does NOT autonomously drive the editor.
--
-- Requires the `claude` CLI on PATH (installed separately; see README).
-- Docs: https://github.com/coder/claudecode.nvim
--
-- VERIFY AT FIRST RUN: this is the newest/most-moving plugin here. Confirm the repo
-- name and command surface are current before relying on it (see README).
--
-- PROVISIONAL keymaps under <leader>a ([A]gent) — revisit after /teach vim.

return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' }, -- used for the terminal split UI.
  opts = {},                              -- defaults: auto-starts the WebSocket server.
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code terminal' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude Code' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection to Claude' },
    -- Diff review of a proposed edit:
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept proposed diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny proposed diff' },
  },
}
