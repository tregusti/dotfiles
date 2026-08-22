Status: done

# Step 2 — the tracer bullet: end-to-end dark/light switch

See `../PRD.md` for full context and the mandatory Process section before
touching anything below. Depends on step 1 (truecolor override) being
done and confirmed.

## What

Create three new files under `dots/.config/tmux/theme/`:

- `selenized-dark.conf` — sets `@so_bg` and `@so_fg` (dark values from the
  PRD's palette table: `bg_0 #103c48`, `fg_0 #adbcbc`) via
  `set -g @so_bg '#103c48'` / `set -g @so_fg '#adbcbc'`.
- `selenized-light.conf` — same two variable names, light values
  (`bg_0 #fbf3db`, `fg_0 #53676d`).
- `layout.conf` — one line: `set -g status-style "bg=#{@so_bg},fg=#{@so_fg}"`.

Then in `tmux.conf`:

- `source-file` `theme/layout.conf` once, unconditionally, near the top of
  the theme section.
- Point the existing `client-dark-theme` / `client-light-theme` hooks
  (currently unused on this branch — this branch was cut from `main`
  before catppuccin added them) at sourcing `theme/selenized-dark.conf` /
  `theme/selenized-light.conf` respectively.
- Source one of the two palette files unconditionally as a startup
  default (pick dark, matches catppuccin branch's prior default choice —
  confirm with user which default they want, don't assume).

## Why this, why now

This is the tracer bullet: the thinnest possible end-to-end slice through
every subsystem the whole theme depends on — Ghostty's DEC 2031 report →
tmux's `client-dark-theme`/`client-light-theme` hooks → a sourced palette
file → a layout file that reads that palette live via `#{@so_bg}` format
expansion. Nothing here is decorative; it's the exact mechanism that broke
in catppuccin (`message-command-style align=centre`), minus that specific
option — proving this now, before any status-line segments exist, means
any future segment work sits on a verified-working foundation instead of
compounding on an unproven one.

The `#{@so_bg}` reference in `layout.conf` is why `layout.conf` never
needs to be re-sourced on switch: tmux expands `#{@variable}` at render
time, not at `set` time, so changing `@so_bg` alone (by sourcing a
different palette file) is enough for the next redraw to pick it up.

## Verify

`prefix r`, then toggle macOS system appearance (System Settings →
Appearance) and confirm the tmux status bar's background flips between
the dark and light `bg_0` colors without needing a manual reload. This is
the step that actually proves the switch works, not just that colors
render.

## Comments

Implemented and verified 2026-08-21. Deviations from the original spec
above, agreed with the user mid-implementation:

- Palette variable naming corrected from `@so_*` to `@color_*`, with role
  names matching upstream selenized-values exactly (`bg_0`, `fg_0`, ...) —
  see PRD decision table.
- Boot default is **light**, not dark (spec had left this an open question
  for the user; they picked light).
- Theme wiring (`source-file layout.conf`, the two `client-*-theme` hooks,
  the boot-default source) was factored out of `tmux.conf` into a new
  `theme/theme.conf`, sourced with a single line from `tmux.conf`.
- Verification surfaced a real blocker not anticipated in this issue:
  Ghostty had no `theme` directive configured, so it never emitted the DEC
  mode 2031 report tmux's hooks depend on — tmux's `#{client_theme}` was
  stuck on whatever it saw at attach. Filed and resolved via companion
  ticket `.scratch/ghostty-selenized-theme/issues/01-theme-ghostty-selenized.md`
  (`dots/.config/ghostty/config` now sets
  `theme = dark:Selenized Dark,light:Selenized Light`). With that in place,
  `#{client_theme}` and the tmux status-bar background both confirmed
  flipping live on macOS Appearance toggle, no manual reload needed.
