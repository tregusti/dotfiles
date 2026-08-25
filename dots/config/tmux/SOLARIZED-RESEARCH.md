# Solarized tmux theme research

Research only (2026-08-21). Evaluating replacements for the paused catppuccin
setup (branch `tmux-catppuccin-theme`), which has two problems: disliked
palette, and an unresolved bug where `message-command-style align=centre`
correctly centers the _rendered_ prompt but typed keystrokes still echo at
column 0, overwriting the window list. tmux 3.7c (Homebrew), plugin manager is
`tpack` (installs under `~/.config/tmux/plugins/...`, not tpm's
`~/.tmux/plugins/...`).

## 1. Options surveyed

| Repo                                                                                                                      | Stars | Last push                         | Structure                                                                                                                                                                                                               | Sets `message-command-style`?                                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------------- | ----- | --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [seebi/tmux-colors-solarized](https://github.com/seebi/tmux-colors-solarized)                                             | 1104  | 2022-06-09                        | 4 static raw-option snippets (`tmuxcolors-{256,dark,light,base16}.conf`), append-or-source                                                                                                                              | **No** — sets `message-style` only                                                                                                                         |
| [mkoga/tmux-solarized](https://github.com/mkoga/tmux-solarized)                                                           | 20    | 2023-01-30                        | Light-only, powerline-style shell script                                                                                                                                                                                | not checked (light-only, doesn't fit dual-flavor need)                                                                                                     |
| [Carltoffel/tmux-solarized](https://github.com/Carltoffel/tmux-solarized) ("Catppuccin tmux theme with solarized colors") | 0     | 2024-05-06                        | Independent reimplementation of catppuccin's _architecture_ (`status/`, `window/`, `pane/`, `builder/`, `custom/` module dirs; `@solarized_flavour` light/dark option) with built-in `battery.sh` + `gitmux.sh` modules | **Yes** — confirmed in `solarized.tmux` lines 74-75: `set message-command-style "...,align=centre"`, byte-for-byte the same pattern as catppuccin          |
| [johnstegeman/solarized-tmux](https://github.com/johnstegeman/solarized-tmux)                                             | 0     | 2024-03-01                        | Literal git fork of `catppuccin/tmux` with one added `solarized-osaka` flavor file; `catppuccin.tmux` and `catppuccin-*.tmuxtheme` files still present verbatim                                                         | **Yes** — it _is_ catppuccin's code, unmodified in this respect                                                                                            |
| [MiohitoKiri5474/solarized-osaka-tmux](https://github.com/MiohitoKiri5474/solarized-osaka-tmux)                           | 0     | 2025-08-07 (most recently active) | Forked from `janoamaral/tokyo-night-tmux` (independent engine, not catppuccin-derived); ships `battery-widget.sh`, `datetime-widget.sh`, `git-status.sh`, plus netspeed/cmus/path widgets                               | **No** — sets `message-style`/`message-command-style` but without `align=centre` (default/left alignment), confirmed in `solarized-osaka.tmux` lines 21-22 |
| Hand-rolled raw `status-*`/`window-status-*`/`message-style` options using the 16 Solarized values directly               | —     | —                                 | Whatever the user writes                                                                                                                                                                                                | Only if the user adds it themselves — trivially avoided by omission                                                                                        |

Note: `zzamboni/tmux-solarized-theme` does not appear to exist (zzamboni is
known for a zsh-side solarized/prompt theme, not tmux); dropped from
consideration.

### Verified content: seebi's dark conf (full file)

```
set-option -g status-style fg=yellow,bg=black
set-window-option -g window-status-style fg=brightblue,bg=default
set-window-option -g window-status-current-style fg=brightred,bg=default
set-option -g pane-border-style fg=black
set-option -g pane-active-border-style fg=brightgreen
set-option -g message-style fg=brightred,bg=black
set-option -g display-panes-active-colour brightred
set-option -g display-panes-colour blue
set-window-option -g clock-mode-colour green
set-window-option -g window-status-bell-style fg=black,bg=red
```

Flat, solid single-color backgrounds throughout — no gradients, no powerline
chevrons, no separators — matching the user's stated preference. No
`status-left`/`status-right` at all: it's a bare color canvas, not a segment
framework. No git/battery integration.

## 2. Light/dark auto-switching compatibility

The working mechanism today: Ghostty emits a DEC 2031 report on macOS appearance
change → tmux's built-in `client-dark-theme`/`client-light-theme` hooks fire →
currently these flip `@catppuccin_flavor` and re-run `catppuccin.tmux` to
redraw.

- **seebi**: no single "flavor" option — it's two separate static files. Wiring
  is: point each hook at `run-shell "tmux source-file .../tmuxcolors-dark.conf"`
  (and `-light.conf` for the light hook) instead of flipping a variable and
  re-running a script. Same hook mechanism, slightly different target (a file,
  not an option+rerun). Straightforward.
- **Carltoffel**: has `@solarized_flavour light|dark`, structurally identical
  wiring to what's used today (flip option, re-run `solarized.tmux`) — but
  carries the align=centre bug, so this compatibility advantage doesn't matter
  if the bug reproduces.
- **johnstegeman**: same as Carltoffel in spirit — it's catppuccin's own
  flavor-switching plumbing, just with a `solarized-osaka` value added to the
  flavor enum — but still catppuccin's message-command-style code path.
- **MiohitoKiri5474**: no evident light variant (it's a dark "Osaka" aesthetic
  ported from an nvim colorscheme, not true dual-flavor Solarized). The hook
  mechanism has nothing to switch _to_ — a dead end for this requirement unless
  the user builds a light palette from scratch, which defeats the point of
  adopting it for its ready-made segments.
- **Hand-rolled**: same idea as seebi but the user owns both palettes directly
  (two conf snippets or two `if-shell` branches), picked by the existing hooks.
  Most manual, most transparent — no plugin abstraction to fight when something
  doesn't redraw right.

## 3. Status-line segments

- **Battery**: already solved regardless of theme choice — `tmux-battery` is
  already installed and exposes `#{battery_percentage}`, `#{battery_icon}`,
  `#{battery_remain}`, `#{battery_color_fg}` / `#{battery_color_bg}` as ready
  format variables. Any hand-written `status-right` can use these directly; no
  theme plugin needed for this piece specifically. Carltoffel additionally ships
  a styled `battery.sh` module wrapping this, but it's not required.
- **Time**: trivial everywhere — plain `strftime` tokens (e.g. `%H:%M`) in
  `status-right`. No plugin involved in any approach.
- **Git branch**: catppuccin's approach (and Carltoffel's, which copies it) uses
  **gitmux**, a compiled Go binary that renders a fuller git-status widget
  (branch + staged/unstaged/ahead-behind glyphs) in one process invocation.
  Since gitmux is already installed and working for the user, it can be reused
  directly in a hand-rolled or seebi-based `status-right` via `#(gitmux ...)` —
  adopting it doesn't require adopting catppuccin's or Carltoffel's surrounding
  script layer. Alternative: a plain shell-out, e.g.
  `#(cd #{pane_current_path} && git branch --show-current)`. Simpler, zero extra
  binary, but forks+execs `git` on every status-bar redraw (governed by
  `status-interval`, default redraws every 15s, plus on most tmux events) for
  the active pane's path — can add perceptible lag on a slow/network filesystem
  if `status-interval` is set aggressively low. gitmux avoids repeated `git`
  subprocess spawns by being one fast binary doing the equivalent work, and it's
  already proven to work in the user's environment today.

## 4. Maintenance / effort summary

| Repo                                 | Activity signal                                                                                                                                | tmux.conf hand-writing required                                                                                                                                                                                          |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| seebi/tmux-colors-solarized          | Stable, unmaintained since 2022 but very widely used (1.1k★), simple enough that "unmaintained" barely matters — it's ~10 lines of raw options | Low: source the snippet, then hand-write `status-left`/`status-right` (battery/time/gitmux) and the two-file hook wiring yourself                                                                                        |
| Carltoffel/tmux-solarized            | Low adoption (0★), last pushed 2024-05, actively structured but unproven                                                                       | Low config-only (mirrors catppuccin's option surface) — but inherits the bug                                                                                                                                             |
| johnstegeman/solarized-tmux          | Low adoption (0★), last pushed 2024-03, is literally catppuccin                                                                                | Low config-only — but inherits the bug (it's catppuccin)                                                                                                                                                                 |
| MiohitoKiri5474/solarized-osaka-tmux | Actively pushed as recently as 2025-08, 0★                                                                                                     | Low config-only, but heavier runtime dependency footprint (bash ≥4, `bc`, `gawk`, `jq`, `gsed`, coreutils, optionally `nowplaying-cli`) — more moving parts than the user's current lean plugin set, and no light flavor |
| Hand-rolled from scratch             | N/A — nothing to go stale                                                                                                                      | Highest: user writes and maintains all `status-*`/`window-status-*`/`message-style` options and both flavor tables directly                                                                                              |

## Recommendation

**Prototype first: hand-rolled raw solarized options, modeled on seebi's file.**
Use seebi's dark/light conf snippets as the canonical, already-solid
Solarized-16 color reference (borrow the exact hex/ANSI mapping rather than
re-deriving it), but extend by hand with a `status-right` combining the
already-installed `tmux-battery` format variables, the already-working `gitmux`
binary, and a clock token — then wire the existing
`client-dark-theme`/`client-light-theme` hooks to `source-file` between two
static conf snippets (dark/light) instead of flipping `@catppuccin_flavor`.

This directly satisfies every stated constraint:

- Solid/flat colors, no gradients — matches seebi's style and the user's taste.
- Guaranteed to avoid the `align=centre` bug, because nothing sets
  `message-command-style` unless deliberately added — and there's no reason to
  add it.
- Zero new dependencies beyond what's already installed (`tmux-battery`
  binary/plugin, `gitmux` binary already present from the catppuccin setup).
- No third-party staleness risk to track — the two 0★ solarized-flavored
  catppuccin forks are both unproven _and_ confirmed to carry the exact bug
  being escaped, so they're not worth prototyping.
- Same hook-based light/dark plumbing already proven to work, just re-pointed at
  a file-source instead of an option-flip.

Cost is explicit and bounded: hand-writing/adapting roughly 30-50 lines of raw
tmux options, twice (once per flavor) — a one-time effort, not an ongoing
plugin-version-tracking burden.

**Explicitly avoid**: `Carltoffel/tmux-solarized` and
`johnstegeman/solarized-tmux` — both confirmed via source to set
`message-command-style ...,align=centre`, i.e. they would very likely reproduce
the exact bug this migration is meant to escape, on top of being essentially
unvetted (0 stars, thin community exposure).

**Worth a glance but not adopting wholesale**:
`MiohitoKiri5474/solarized-osaka-tmux` is a useful reference for its widget
shell-script structure (it _doesn't_ set `align=centre` either, so it also
avoids the bug), but it's dark-only and pulls in a heavier dependency chain
(`gawk`, `jq`, `bc`, `gsed`, etc.) than needed for a light/dark-pair Solarized
setup — its widget scripts could be skimmed for ideas rather than installed as a
plugin.
