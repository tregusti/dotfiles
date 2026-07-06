# 2. Hand-authored modular config, seeded from kickstart.nvim

Date: 2026-07-06

## Status

Accepted

## Context

Three ways to build a Neovim config were considered:

1. **A distribution** (LazyVim, NvChad, AstroNvim) — a pre-built "IDE in a box".
   The settings live inside the distro's own source, overridden via opaque spec
   tables. This defeats the primary goal: a config where every setting is
   visible, understood, and documented with a citable source.
2. **Hand-rolled from zero** — maximum understanding but slow and error-prone;
   a previous manual attempt (~2018–2020) stalled because of the sheer volume of
   boilerplate.
3. **`kickstart.nvim` as a seed** — a single, ~1000-line, exhaustively commented
   `init.lua` under the official `nvim-lua` org. Explicitly *not* a distro: it is
   meant to be read, understood, and owned. It wires up the modern core stack
   (LSP, completion, Treesitter, Telescope) with minimal, well-referenced choices.

## Decision

Seed the configuration from **kickstart.nvim's choices and structure**, but
**re-author it into this repo as small, single-responsibility Lua modules** rather
than one monolithic file. Every non-obvious setting carries a comment citing its
source (`:help` topic or the plugin's documentation).

Use **`lazy.nvim`** as the plugin manager (kickstart's default): lazy-loading,
a committed lockfile (`lazy-lock.json`) for reproducibility, and a declarative
spec format.

## Consequences

- Kickstart gives battle-tested completeness; the modular split and inline
  citations give navigability and the "I understand every piece" property.
- Divergence from upstream kickstart is expected and fine — it is a seed, not a
  dependency. There is no automatic way to pull upstream updates; changes are
  adopted deliberately by reading them.
- `lazy-lock.json` is committed so plugin versions are reproducible across machines.
