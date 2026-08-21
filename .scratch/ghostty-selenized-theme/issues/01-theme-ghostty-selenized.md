Status: ready-for-agent

# Theme Ghostty itself to Selenized, dark/light pair

`~/.config/ghostty/config` (repo path `dots/.config/ghostty/config`) currently
has no `theme` directive at all — just `macos-option-as-alt = left`.

Discovered while wiring up the hand-rolled tmux Selenized theme (branch
`tmux-solarized-theme`, see `.scratch/tmux-selenized-theme/PRD.md` step 2):
without a `theme = light:X,dark:Y` pair configured, Ghostty has no dark/light
state to track, so it never emits the DEC mode 2031 change report that
tmux's `client-dark-theme`/`client-light-theme` hooks depend on — tmux's
one-time query at attach just answers with whatever Ghostty's static
background happens to be, and never updates after that. The prior
catppuccin-theme branch's `dots/.config/ghostty/config` set
`theme = dark:Catppuccin Mocha,light:Catppuccin Latte` and this reportedly
did work end-to-end at the time.

Names in the `theme =` directive aren't arbitrary labels — they must resolve
to a real Ghostty theme (built-in or user-defined under
`~/.config/ghostty/themes/`). Ghostty already ships built-in Selenized
themes, confirmed via `ghostty +list-themes | grep -i selenized`:

```
Selenized Black (resources)
Selenized Dark (resources)
Selenized Light (resources)
```

## What

- Set in `dots/.config/ghostty/config`:
  ```
  theme = dark:Selenized Dark,light:Selenized Light
  ```
- This also unblocks the tmux Selenized theme's auto dark/light switching
  (`.scratch/tmux-selenized-theme/`, step 2) — Ghostty needs to be emitting
  the mode 2031 report for that to work at all.

## Things to check before calling this done

- Ghostty's bundled `Selenized Dark`/`Selenized Light` themes are
  third-party-sourced (`iTerm2-Color-Schemes`-derived, per Ghostty's
  `(resources)` tag) — verify their hex values against upstream
  `jan-warchol/selenized` and against the already-verified palette table in
  `.scratch/tmux-selenized-theme/PRD.md`. If they drift, either accept the
  drift or define a custom Ghostty theme file under
  `~/.config/ghostty/themes/` using the PRD's exact hex instead of the
  bundled one.
- Confirm the "Selenized Black" variant (also bundled) isn't a better dark
  fit than "Selenized Dark" — PRD's dark palette uses `bg_0 #103c48`; check
  which bundled theme's background matches that.
- After setting, reload Ghostty config (`Cmd+Shift+,` or restart) and verify
  `tmux display-message -p '#{client_theme}'` actually flips when toggling
  macOS Appearance, confirming the mode 2031 report now reaches tmux.

## Comments
