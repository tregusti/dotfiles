Status: ready-for-human

# Switch nvim's solarized.nvim palette to selenized

`dots/.config/nvim/lua/plugins/colorscheme.lua` uses `maxmx03/solarized.nvim`
with `opts = {}`, which defaults to `palette = 'solarized'`
(`solarized/config.lua:88`). During the tmux solarized-theme grilling session
(branch `tmux-solarized-theme`) the user picked the `selenized` variant for
tmux instead of classic Solarized, after seeing its bundled palette values,
and wants nvim switched to match so the two stay visually consistent.

`maxmx03/solarized.nvim` already bundles `selenized` as a built-in
`palette` option (`solarized/palette/init.lua` and
`solarized/palette/solarized-light.lua`, both verified against upstream
[jan-warchol/selenized](https://github.com/jan-warchol/selenized) hex
values) — this should be a one-line config change:

```lua
opts = { palette = 'selenized' },
```

## Things to check before calling this done

- `tint_diff_highlights()` in the same file reads `colors.git_add` /
  `colors.git_modify` / `mix_green` / `mix_orange` / `mix_red` — confirm
  these keys exist on the `selenized` palette table too (they did in the
  version checked during this ticket's research) and that the blended
  gitsigns colors still read well against selenized's bg tones.
- `lualine.lua`'s `uncommitted` component reads `colors.base3` /
  `colors.diag_warning` directly via `require('solarized.utils').get_colors()`
  — same check, confirm those keys exist and still contrast correctly.
- Eyeball both light and dark mode after switching (auto-dark-mode.nvim
  flips `vim.o.background` on OS appearance change).

## Comments

Made the one-line change in `dots/.config/nvim/lua/plugins/colorscheme.lua`
(`opts = { palette = 'selenized' }`) and updated the top comment to mention
the selenized variant.

Verified before calling it done:
- `M.selenized` in both `solarized/palette/init.lua` (dark) and
  `solarized/palette/solarized-light.lua` (light) define all the keys
  `tint_diff_highlights()` reads: `base3`, `git_add`, `git_modify`,
  `mix_green`, `mix_orange`, `mix_red`.
- `lualine.lua`'s `uncommitted` component keys (`base3`, `diag_warning`)
  are present too.
- Headless nvim loads `colorscheme solarized` cleanly with
  `vim.o.background` set to both `dark` and `light` — no errors.

Not done: actually eyeballing light/dark mode in a real terminal for visual
quality — that's a human judgment call, left for you to check.
