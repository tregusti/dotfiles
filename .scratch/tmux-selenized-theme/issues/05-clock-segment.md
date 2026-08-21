Status: ready-for-human

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
