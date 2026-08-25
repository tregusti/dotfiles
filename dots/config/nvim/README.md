# Neovim config

A hand-authored, documented Neovim configuration. Seeded from
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) but split into small
modules, with every non-obvious setting carrying an inline citation (`:help '<name>'`
for built-ins, a doc link for plugins). The big decisions live in
[`../../../docs/adr/`](../../../docs/adr/).

Linked into place by `install.sh` as `~/.config/nvim`. The previous classic-Vim
config is retired to [`../../../legacy/`](../../../legacy/).

## Layout

```
init.lua                     Entry point. Sets leader, then loads the modules below.
lua/config/
  options.lua                Editor options (numbers, indent, search, UI, files).
  keymaps.lua                Non-plugin keymaps (minimal — see "Provisional" below).
  lazy.lua                   Bootstraps the lazy.nvim plugin manager.
lua/plugins/                 One file per concern; each returns a lazy.nvim spec.
  colorscheme.lua            Solarized + auto-dark-mode (follows macOS light/dark).
  lualine.lua                Statusline.
  telescope.lua              Fuzzy finder (files, grep, symbols, ...).
  treesitter.lua             Syntax parsing for highlight + indent.
  lsp.lua                    Language servers (mason + lspconfig); ESLint lives here.
  completion.lua             nvim-cmp + LuaSnip (on-demand menu, no ghost text).
  lua-dev.lua                lazydev — nice editing of this config.
  conform.lua                Formatting (prettierd/stylua/shfmt), format-on-save.
  linting.lua                oxlint via nvim-lint, gated on a project oxlint config.
  git.lua                    gitsigns (gutter + hunk ops).
  which-key.lua              Leader-key discovery popup.
  editing.lua                mini.surround / mini.ai / mini.pairs.
  agent.lua                  Claude Code companion (diff review + selection).
```

## External dependencies

Installed via Homebrew (the brewfiles were retired; install these directly):

```sh
brew install neovim ripgrep fd
# a Nerd Font for icons, e.g.:
brew install --cask font-symbols-only-nerd-font
```

- **ripgrep** — Telescope live-grep and `:help grep`.
- **fd** — Telescope file finding.
- **Nerd Font** — glyphs in lualine/Telescope/which-key. Set your terminal to use it
  (or one that patches in symbols). Without it, icons render as boxes; set
  `vim.g.have_nerd_font = false` in `init.lua` to disable icons instead.
- **node** — required by the JS/TS/Vue/Tailwind/ESLint language servers (already installed).
- **claude** CLI — for the agent companion (`agent.lua`), installed separately.

Language servers, formatters, and linters install themselves on first launch via
[mason](https://github.com/williamboman/mason.nvim) — no manual step.

## First run

1. `brew install neovim ripgrep fd` (+ a Nerd Font).
2. `cd ~/.dotfiles && ./install.sh` (symlinks `~/.config/nvim`).
3. Open `nvim`. lazy.nvim self-installs, then installs the plugins; mason installs the
   servers/tools. Let it finish, then restart.
4. `:checkhealth` to confirm the environment; `:Lazy` to inspect plugins; `:Mason` to
   see installed servers/tools.

Plugin versions are pinned in `lazy-lock.json` (committed) for reproducibility.

## Known first-run gotchas

Two areas are the most version-sensitive and worth verifying on the first launch:

1. **Vue + TypeScript hybrid mode** (`lsp.lua`) — `ts_ls` loads `@vue/typescript-plugin`
   from the mason-installed Vue server. If `.vue` files don't get completion/diagnostics,
   check the [vue_ls README](https://github.com/vuejs/language-tools) for the current wiring.
2. **oxlint** (`linting.lua`) — relies on nvim-lint's bundled oxlint spec. If oxlint
   diagnostics don't appear in a project that has `.oxlintrc.json`, verify the linter
   name/output format against [nvim-lint](https://github.com/mfussenegger/nvim-lint).

## Keymaps and leader-key ergonomics

Keymaps, leader-key groupings, and the mini.nvim/gitsigns/LSP/Telescope/agent
mapping sets were deliberately left provisional until relearning Vim (tracked via
a `/teach` session in `teach/nvim/`), then finalized through a grilling session.
Nothing in the config is marked `PROVISIONAL` anymore. File explorer is
`folke/snacks.nvim`'s picker-based explorer (`<C-e>`), not `netrw`.
