# Hot-reload the Neovim config without restarting

Status: needs-triage

## Problem

Editing `lua/plugins/*.lua` or `lua/config/*.lua` and then running
`:source $MYVIMRC` does **not** pick up the change. `require()` caches modules
by name, so re-executing `init.lua` just hits the cache — it doesn't re-run
the plugin spec file or re-register its keymaps. Right now the only reliable
way to pick up a config edit is a full Neovim restart.

Discovered while iterating on `lua/plugins/agent.lua` (Claude Code companion)
and `lua/plugins/telescope.lua` (hidden-files keymap) during the nvim
`/teach` session — see `teach/nvim/`.

## Desired outcome

Some way to re-apply a config/plugin-spec change without a full restart.
Options to evaluate (not yet decided):

- An autocmd on `BufWritePost` for files under `lua/config/` and
  `lua/plugins/`, clearing the relevant `package.loaded` entries and
  re-requiring, similar to patterns folke and others publish for lazy.nvim
  configs.
- A manual `:lua` snippet / user command that does the same thing on demand,
  rather than an automatic watcher.
- Just formalize "restart is the reload mechanism" and skip this — worth
  weighing the added config complexity against how often this friction
  actually bites in practice.

## Constraints

- Should not conflict with the PARKED keymap/ergonomics decisions still
  waiting on the nvim `/teach` session (see `docs/adr/`, nvim README
  "Provisional pieces").
- Low priority / quality-of-life — not blocking anything.
