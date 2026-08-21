Status: ready-for-human

# Step 4 — window list styling (active vs inactive)

See `../PRD.md` for full context and the mandatory Process section before
touching anything below. Depends on step 3 (session name segment).

## What

Set `window-status-format` and `window-status-current-format` in
`theme/layout.conf`, giving the active window a distinct solid accent
(different from the session-name accent chosen in step 3) and inactive
windows a muted/dim tone (`@so_dim` or similar, from the palette's
`dim_0` role).

## Why this, why now

Most-used piece of the bar day to day (this is what you glance at to know
which window you're in), and the natural next segment after session name
since it's still `status-left`-adjacent territory before moving to
`status-right` segments in steps 5–7.

## Verify

`prefix r`, create a couple of test windows (`prefix c`), confirm active
vs inactive are visually distinct and the current window is unambiguous
at a glance.

## Comments
