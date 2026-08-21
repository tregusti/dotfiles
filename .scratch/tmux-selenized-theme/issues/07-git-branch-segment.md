Status: ready-for-human

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
