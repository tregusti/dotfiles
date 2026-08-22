Status: done

# Step 7 — git branch segment (status-right)

See `../PRD.md` for full context and the mandatory Process section before
touching anything below. Depends on step 6. Last step in the plan.

## What

Add a `status-right` component in `theme/layout.conf` shelling out to
`gitmux` (already installed at `/opt/homebrew/bin/gitmux`, no plugin
install needed) — e.g. `#(gitmux -cfg ~/.config/tmux/.gitmux.conf
#{pane_current_path})`, styled with a solid accent. Check whether a
`gitmux` config file already exists anywhere in the repo (it may on the
catppuccin branch — `git show tmux-catppuccin-theme:dots/.config/tmux
--name-only` — for reference format only, don't copy catppuccin-specific
styling) or needs to be created fresh for solid Selenized coloring.

## Why this, why now

Last segment — reuses an already-installed binary rather than adding a
new dependency, so it's the lowest-risk piece to save for last. Also the
one most likely to want a config file of its own (gitmux has its own
color/format config), so worth doing once everything else on the bar is
already settled and visually stable.

## Verify

`prefix r` inside a git repo pane, confirm the current branch name
renders; `cd` between a git repo and a non-git directory and confirm the
segment updates/disappears sensibly rather than showing stale or
erroring.

## Comments

Implemented 2026-08-22. New `theme/gitmux.conf` created from scratch (no
prior config existed on this branch or on `tmux-catppuccin-theme`), only
`branch` style pulled from the Selenized palette
(`#[fg=#{@color_bg_0},bg=#{@color_fg_0}]`); other elements (divergence,
staged/modified/untracked/stashed flags, insertions/deletions) still use
generic tmux color names (`cyan`, `yellow`, `green`, `red`, `magenta`),
not yet mapped to `@color_*` roles — left as a possible future touch-up,
not blocking. Segment placed in `status-left` (via `@theme_git_branch`,
composed with the session name) rather than `status-right` as the
original plan sketched — user's call once the bar's layout was actually
visible.

Also required introducing shared `@theme_block_*` helper vars
(`@theme_block_default`, `@theme_block_inverted`, `@theme_block_blue`) to
avoid repeating `#[fg=...,bg=...]` per segment, which surfaced a real
tmux gotcha: a var-referencing-a-var needs an explicit `#{E:@var}` at
*each* level of indirection, not just at the outermost use site — the
`@theme_git_branch`/`@theme_time` definitions initially referenced
`#{@theme_block_*}` without `E:`, leaving the block var's own nested
`#{@color_*}` tokens unexpanded. Fixed by wrapping the inner reference as
`#{E:@theme_block_*}` inside each segment's own definition.

This was the last step in the plan (steps 1–7 all done).
