# 3. Agent integration: terminal workflow + Claude Code companion, no in-editor assistant

Date: 2026-07-06

## Status

Accepted

## Context

Modernising to Neovim is motivated substantially by agent integration. Four
distinct interaction models were distinguished:

1. **Agent in a terminal split** — Claude Code runs in Neovim's built-in
   `:terminal`, reading and writing files on disk. Editor is untouched.
2. **Companion plugin** — a Neovim plugin that speaks Claude Code's IDE-integration
   protocol (the same WebSocket protocol used by the VS Code / JetBrains
   extensions). Proposed edits open as native Neovim diff splits to accept/reject,
   and the current selection/file is shared as context. This is a narrow, useful
   form of "the agent talks to the editor" — the tool drives it, it is not
   hand-built.
3. **In-editor AI assistant** — a chat/edit sidebar such as `codecompanion.nvim`
   for "select code → ask" interactions, configured with an API key. Distinct from
   task-oriented Claude Code.
4. **Full editor automation** — the agent autonomously driving the session
   (cursor, arbitrary buffers). Explicitly unwanted.

## Decision

Build **(1) + (2)**: the built-in terminal workflow plus a Claude Code companion
plugin for native diff review and selection sharing.

Do **not** build (3) or (4). No in-editor AI assistant is installed, and none is
scaffolded — not even a disabled stub. It can be added later as a deliberate,
separately documented change if a concrete need appears.

No live/inline completion of any kind.

## Consequences

- The agent's role is bounded to reading/writing files plus showing diffs and
  reading the current selection. It never autonomously drives the editor.
- The config stays honest and fully understood — no AI plugin is present that the
  owner has not evaluated and chosen.
- Adding an on-demand assistant later is a clean, additive change (its own module,
  its own ADR), not a refactor.
- The specific companion plugin (e.g. `coder/claudecode.nvim`) is confirmed at
  build time against what is current and maintained.
