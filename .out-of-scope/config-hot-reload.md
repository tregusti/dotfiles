# Neovim Config Hot-Reload

This repo does not build a mechanism to reload the Neovim config (options,
keymaps, plugin specs) without a full restart.

## Why this is out of scope

The original motivation was friction while iterating on plugin files
(`agent.lua`, `telescope.lua`) during a `/teach` session, where restarting
Neovim meant losing the working session. That cost has since gone away:
session restore (`<leader>QS`, after `<leader>QQ` to quit) makes a full
restart cheap enough that hot-reload machinery isn't worth building.

It's also worth noting that half of this problem is already solved for free,
which further lowers the value of building anything custom:

- `lua/plugins/*.lua` files are lazy.nvim plugin specs. lazy.nvim already
  ships `:Lazy reload <plugin>` (`lazy/core/loader.lua`), which properly
  clears a plugin's module cache and re-runs its `config`/`keys`, cleanly
  picking up spec edits. No custom code needed — just run the command.
- `lua/config/*.lua` (`options.lua`, `keymaps.lua`, `buffers.lua`,
  `window-dim.lua`) has no equivalent, since these are plain `require()`s
  from `init.lua`, not lazy-managed specs. A true "reload everything, no
  side effects" story would additionally require wrapping
  `window-dim.lua`'s `ColorScheme` autocmd in a `clear = true` augroup
  first — it's currently registered with no group, so a naive re-require
  would duplicate it on every reload. Bounded, but not zero effort, and not
  worth it now that restart is cheap.

If restart ever becomes expensive again (e.g. session restore stops
covering the relevant state), `:Lazy reload <plugin>` is still there for
the plugin-spec half, and only the `lua/config/*.lua` half would need
revisiting.

## Prior requests

- `.scratch/nvim-config-hot-reload/PRD.md` — "Hot-reload the Neovim config
  without restarting"
