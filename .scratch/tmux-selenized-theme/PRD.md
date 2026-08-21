# Hand-rolled Selenized tmux theme

Status: in-progress

## Problem

catppuccin/tmux theming (branch `tmux-catppuccin-theme`) is paused: the
user dislikes catppuccin's colors, and hit an unresolved bug where
`message-command-style align=centre` correctly centers the rendered
command-prompt (`prefix :`, rename) but typed keystrokes still echo at
column 0, overwriting the far-left window list. Full history in
`dots/.config/tmux/SOLARIZED-RESEARCH.md` (uncommitted, on branch
`tmux-solarized-theme`) and the catppuccin branch's `THEME-PROBLEM.md`.

Research (that file) surveyed existing solarized-flavored tmux plugins;
the two that mimic catppuccin's architecture (`Carltoffel/tmux-solarized`,
`johnstegeman/solarized-tmux`) were confirmed by source inspection to
carry the same `align=centre` line — likely to reproduce the same bug.
Recommendation: hand-roll a raw tmux.conf theme instead of adopting a
plugin, so nothing sets `message-command-style` at all.

Mid-grilling, the user separately wants the tmux theme to visually match
their nvim colorscheme (`maxmx03/solarized.nvim`), and after seeing that
plugin's bundled palette data, picked the **selenized** variant over
classic Solarized — see [[nvim-selenized-palette]]
(`.scratch/nvim-selenized-palette/`) for the companion ticket to swap nvim
to the same palette (separate piece of work, not part of this feature).

Step 2 (dark/light switch) surfaced that Ghostty itself has no `theme`
directive configured, so it never emits the DEC mode 2031 change report
tmux's `client-dark-theme`/`client-light-theme` hooks depend on — see
[[ghostty-selenized-theme]] (`.scratch/ghostty-selenized-theme/`) for the
companion ticket to give Ghostty a Selenized dark/light pair. That ticket
is a **blocker** for finishing step 2's verification (the auto-switch can't
be confirmed end-to-end until Ghostty is emitting the report), even though
it's tracked as separate work.

## Desired outcome

A hand-rolled tmux status-line theme, built and verified one tracer-bullet
step at a time (not all at once — see Process below), delivering:

- Solid Selenized colors (no gradients), matching nvim's palette exactly.
- Automatic dark/light switching, reusing the existing working mechanism:
  Ghostty emits a DEC mode 2031 report on macOS appearance change →
  tmux's built-in `client-dark-theme`/`client-light-theme` hooks fire.
- Status-line segments: session name, window list (active vs inactive),
  clock, battery percentage, current git branch.
- Nothing in the new config sets `message-command-style` or
  `message-style` with `align=centre` — sidesteps the catppuccin bug by
  construction rather than fixing it.

## Decisions (settled via `/grilling` + `/domain-modeling`, 2026-08-21)

| Decision | Answer | Why |
|---|---|---|
| Build order | True tracer-bullet: prove the dark/light switch end-to-end first with a bare background color, *then* thicken with segments | The switch mechanism is where catppuccin's bug lived — proving it first with minimal surface area isolates any future breakage to whatever's added after it |
| Step granularity | One visually-distinct change per step, not one tmux option per step | Single-option steps are too fine-grained to usefully eyeball; each segment (session name, windows, clock, battery, git) is one step |
| Verification | User reloads (`prefix r`) after each step in a live session and confirms visually before the next step | I can't see the user's terminal |
| File structure | `dots/.config/tmux/theme/theme.conf` (wiring: sources `layout.conf`, sets the `client-*-theme` hooks, sources the boot-default palette) + `theme/layout.conf` + `theme/selenized-dark.conf` + `theme/selenized-light.conf`; `tmux.conf` sources only `theme/theme.conf` | Palette vars (`@color_*`) live in the two mode files; `layout.conf` (status-left/right, window-status formats) references `#{@color_*}` and is never re-sourced on switch — tmux expands `#{@var}` live at render time, so only the palette file needs to change. Wiring split into `theme.conf` (step 2 correction) so `tmux.conf` itself stays a single one-line theme touchpoint. DRYer than catppuccin's shell-script-rebuild approach |
| Palette variable naming | `@color_<role>` prefix, roles matching upstream selenized-values names exactly (`bg_0`, `bg_1`, `dim_0`, `fg_0`, `fg_1`, `red`, `green`, ...) | Corrected from an initial `@so_*` naming (step 2) — `so_` read as "solarized," which this theme deliberately isn't; matching upstream selenized-values role names keeps the mapping from PRD table to tmux var obvious |
| Boot default | Light (not dark) | User's choice — corrected from step 2's initial draft, which had assumed dark to match catppuccin's prior default without confirming |
| Palette | Selenized (not classic Solarized), exact hex verified against upstream `jan-warchol/selenized` and cross-checked against the values already bundled in the installed `solarized.nvim` plugin — see table below | User's choice after seeing the palette; wants nvim to match too (companion ticket) |
| Truecolor | `set -ag terminal-overrides ",xterm-256color:RGB"` — scoped to the specific `TERM` value Ghostty negotiates, not a wildcard `,*:RGB` | User has no real remote-tmux-server usage today and no way to test it, but wants insurance against "getting bitten" later without needing to characterize that usage now. A scoped override only activates for a known-good TERM; on some other TERM value it just falls back to tmux's normal 256-color detection instead of blindly forcing 24-bit color at an unverified terminal |
| Git branch segment | Reuse `gitmux` (external binary, already installed at `/opt/homebrew/bin/gitmux`, already used by catppuccin) rather than a raw `git branch --show-current` shell-out in the format string | Avoids a shell-out on every status-line redraw; already a proven dependency |
| Battery segment | Add `tmux-plugins/tmux-battery` plugin (not yet declared on this branch — this branch was cut from `main`, before catppuccin added it) | Provides `#{battery_percentage}` etc. format variables; only the plugin declaration is new, no other catppuccin baggage |

### Selenized palette (verified, hex)

| Role | Dark | Light |
|---|---|---|
| bg_0 | `#103c48` | `#fbf3db` |
| bg_1 | `#184956` | `#ece3cc` |
| dim_0 | `#72898f` | `#909995` |
| fg_0 | `#adbcbc` | `#53676d` |
| fg_1 | `#cad8d9` | `#3a4d53` |
| red | `#fa5750` | `#d2212d` |
| green | `#75b938` | `#489100` |
| yellow | `#dbb32d` | `#ad8900` |
| blue | `#4695f7` | `#0072d4` |
| magenta | `#f275be` | `#ca4898` |
| cyan | `#41c7b9` | `#009c8f` |
| orange | `#ed8649` | `#c25d1e` |
| violet | `#af88eb` | `#8762c6` |

Note: unlike classic Solarized (one fixed 16-tone table, dark/light just
swaps which extreme plays bg vs fg), real Selenized genuinely shifts
*accent* hex between dark/light for contrast — confirmed against upstream.
So `theme/selenized-dark.conf` and `theme/selenized-light.conf` will NOT
be near-identical files with only bg/fg swapped; accents differ too.

## Process (how each step gets added — do not skip this in a fresh session)

For every tracer-bullet step (see `issues/`), before touching any file:

1. Explain to whoever's driving this session *why* this step/line/feature
   is needed, and why it's this step's turn in the order (not earlier,
   not later).
2. Ask whether to add it.
3. Only once they say yes **and** confirm they understand it, add it —
   with a short inline comment describing it.
4. Prefer tables/lists over prose when the info is structured.
5. After adding, the user reloads tmux (`prefix r`) and confirms the
   visual result before moving to the next step.

This applies even if implementation happens in a brand new session with
no memory of the grilling conversation — the issue files below carry
enough context to run this process cold, and mid-step progress (if a
session ends partway through a single issue) should be logged under that
issue file's `## Comments` section before handing off.

## Constraints

- Nothing added may set `message-style` or `message-command-style` with
  `align=centre` — that's the catppuccin bug this whole effort exists to
  avoid.
- Don't touch the catppuccin branch (`tmux-catppuccin-theme`) — it stays
  paused, untouched, for reference only.
- Existing non-theme plugins (`vim-tmux-navigator`, `tmux-resurrect`,
  `tmux-continuum`) are out of scope, don't modify.

## Comments
