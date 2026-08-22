Status: done

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

Implemented 2026-08-22. Active window: `@color_green`, bold, marked with a
`●` glyph; inactive: `@color_fg_0`, marked with a `○` glyph. Both use
`bg=#{@color_bg_0}` explicitly (matching status-style) rather than relying
on inheriting the default. Palette was front-loaded across all steps
first (all 13 base + 8 `br_*` roles added to both mode files in one pass,
per user request, rather than incrementally per step) — see PRD's palette
table and the "front-loaded" note under it.
