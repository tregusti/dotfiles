# 1. Neovim over classic Vim

Date: 2026-07-06

## Status

Accepted

## Context

The existing configuration (`dots/.vimrc`, `dots/.vim/`) targets classic Vim,
written in vimscript with `vim-plug`. The original reason for standardising on
Vim was portability: the owner frequently SSH'd into servers where only Vim was
installed and wanted one config that worked everywhere.

That constraint no longer holds — SSH-to-random-servers is no longer part of the
daily workflow, and a bare default Vim is comfortable enough to use unconfigured
when it does come up.

The new motivation is agent integration and modern tooling. That ecosystem —
built-in LSP, Treesitter, the current plugin landscape, and editor-driving
agents — is overwhelmingly Neovim-first.

## Decision

Build the new configuration for **Neovim**, in **Lua**.

Neovim is a 2014 fork of Vim's C codebase. Relative to Vim it adds: an embedded
LuaJIT runtime (Lua as the native config language), a msgpack-RPC API that makes
the editor scriptable by external tools and agents, a built-in LSP client, native
Treesitter, and a built-in terminal. Vim keybindings and muscle memory carry over.

## Consequences

- Config is Lua, not vimscript. This is a full rewrite, not a port.
- All modern references, tutorials, and plugins assume Neovim, which directly
  supports the goal of a configuration where every setting is documented with a
  citable source.
- Bare-Vim portability as the *primary* target is given up. A minimal (~20-line)
  hand-written `dots/.vimrc` is kept as a bare-Vim fallback for the occasional
  server that has Vim but not Neovim — jk-to-escape plus a handful of
  make-default-Vim-tolerable options, no plugins. This is separate from and much
  smaller than the retired legacy config; Neovim does not read it.
- The old Vim config is preserved (not deleted) so it remains browsable: it is
  moved to a top-level `legacy/` directory (`legacy/.vim/`, `legacy/.vimrc`,
  dot-prefix preserved) and its `link` lines are removed from `install.sh`.
