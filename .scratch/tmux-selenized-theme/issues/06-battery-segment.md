Status: ready-for-human

# Step 6 — battery segment (status-right)

See `../PRD.md` for full context and the mandatory Process section before
touching anything below. Depends on step 5.

## What

- Add `set -g @plugin 'tmux-plugins/tmux-battery'` to `tmux.conf`'s
  plugin section (not yet declared on this branch — confirm with `grep -n
  "@plugin" dots/.config/tmux/tmux.conf` before assuming; it was only
  present on the catppuccin branch). Install via `prefix I` (tpack).
- Add a `status-right` component in `theme/layout.conf` using
  `#{battery_percentage}` (and optionally `#{battery_icon}`), styled with
  a solid accent — consider using the palette's semantic-adjacent choice
  (e.g. yellow/red at low battery) if the user wants a threshold-based
  color rather than one static accent; ask, don't assume.

## Why this, why now

First segment with a new plugin dependency — comes after the
dependency-free segments (steps 3–5) so if something goes wrong here it's
isolated to "the new plugin," not tangled with layout/switch logic
already proven.

## Verify

`prefix r`, confirm battery percentage renders and updates (tmux-battery
refreshes periodically). If on a machine without a battery (desktop /
external monitor session), note that in the Comments section below rather
than blocking — confirm behavior degrades sensibly (e.g. segment blank or
omitted) rather than erroring.

## Comments
