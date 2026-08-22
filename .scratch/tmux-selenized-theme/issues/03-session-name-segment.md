Status: done

# Step 3 — session name segment (status-left)

See `../PRD.md` for full context and the mandatory Process section before
touching anything below. Depends on step 2 (dark/light switch proven).

## What

Add a `status-left` line to `theme/layout.conf` showing the session name
(`#S`) in a solid accent color, using `#{@so_*}` variables (add whichever
accent-color variables are needed — e.g. `@so_blue` — to both
`selenized-dark.conf` and `selenized-light.conf`, using the dark/light
accent hex from the PRD's palette table; remember Selenized's accents
genuinely differ per mode, don't reuse one hex for both files). Also
raise `status-left-length` from tmux's default (10, too short) — the same
truncation bug hit catppuccin.

## Why this, why now

First real content segment, and the simplest one (one variable, no
external data source, no format-string logic) — good next step after
proving the switch mechanism in step 2, before tackling anything with
more moving parts (window list conditionals, external plugin data).

## Verify

`prefix r`, confirm the session name renders in the chosen accent color,
survives a manual reload, and still shows correctly after toggling
dark/light again (re-confirms step 2 didn't regress).

## Comments
