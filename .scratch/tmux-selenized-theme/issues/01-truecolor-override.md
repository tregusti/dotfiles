Status: done

# Step 1 — scoped truecolor override

See `../PRD.md` for full context and the mandatory Process section
(explain → ask → confirm-understood → add-with-comment → user reloads and
confirms) before touching anything below.

## What

Add to `dots/.config/tmux/tmux.conf`:

```
set -ag terminal-overrides ",xterm-256color:RGB"
```

## Why this, why first

Every later step depends on exact Selenized hex rendering correctly.
Without this, tmux won't know the terminal supports 24-bit color and will
downsample everything to its built-in 256-color approximations —
Selenized's exact hex would render wrong from step 2 onward. Doing it
first means every subsequent step is verified against real color from the
start, not retrofitted later.

Scoped to the literal `xterm-256color` TERM value (what Ghostty
negotiates) rather than a wildcard `,*:RGB`, so an unknown/different TERM
elsewhere just falls back to tmux's normal detection instead of blindly
forcing 24-bit color at a terminal that might not support it. See PRD
decision table for the "why scoped" reasoning in full.

## Verify

`prefix r` to reload. No visible change expected yet (no colors have been
set) — this step alone is only provable by the tracer bullet in step 2. If
you want to sanity check truecolor is active now: `tmux info | grep Tc`,
or inside a tmux pane run
`printf '\x1b[38;2;250;87;80mSELENIZED RED\x1b[0m\n'` and confirm the text
renders in that exact red rather than an approximated 256-color red —
optional, not required before moving on to step 2.

## Comments
