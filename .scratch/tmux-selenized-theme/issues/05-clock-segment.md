Status: done

# Step 5 — clock segment (status-right)

See `../PRD.md` for full context and the mandatory Process section before
touching anything below. Depends on step 4.

## What

Add a `status-right` component to `theme/layout.conf` showing the time
via tmux's built-in `%H:%M` (or user's preferred format) strftime
expansion, styled with a solid accent.

## Why this, why now

Simplest possible `status-right` segment — no external plugin, no shelled
command, just a built-in tmux format token. First thing to add on the
right side, before the two segments that carry a real dependency (battery
plugin, gitmux binary) in steps 6–7.

## Verify

`prefix r`, confirm the clock renders and ticks forward on subsequent
reloads/redraws (tmux redraws status periodically on its own — no manual
reload needed to see it advance).

## Comments

Implemented 2026-08-22 by the user directly. `status-right` moved from a
hardcoded `'%H:%M'` in `tmux.conf` into `theme/layout.conf:18`, styled with
a solid `bg=#{@color_blue},fg=#{@color_bg_0}` accent.

Also added, same session but out of the planned step list: a
`@theme_zoomed` status-left segment (`layout.conf:7`) showing a 🔍 glyph
plus `IN`/`OUT` when the current pane is zoomed, via
`#{?window_zoomed_flag,...}`. Session name segment (step 3) refactored
alongside it into a named `@theme_session_name` variable, both composed
into `status-left` via `#{E:...}` expansion. `status-left-length` raised
20 → 40 to fit both.
