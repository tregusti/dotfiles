# Move git config to $XDG_CONFIG_HOME/git/config

Status: needs-triage

## Problem

`install.sh` currently symlinks `dots/.gitconfig` to `~/.gitconfig`:

```
link ~/.dotfiles/dots/.gitconfig ~/.gitconfig
```

Every other piece of config this repo manages that has an XDG-aware option
uses it; `~/.gitconfig` is one of the few remaining top-level dotfiles
cluttering `$HOME`. Git has supported reading config from
`$XDG_CONFIG_HOME/git/config` (falling back to `~/.config/git/config`) since
Git 1.7.12, so there's a native path off `$HOME` without needing an
`[include]` shim.

## Desired outcome

`dots/.gitconfig` (or a renamed equivalent) gets linked to
`$XDG_CONFIG_HOME/git/config` instead of `~/.gitconfig`, and `install.sh` is
updated accordingly.

Open questions to resolve before implementing:

- Precedence: if a stray `~/.gitconfig` still exists on a machine (e.g. not
  yet migrated), git prefers `~/.gitconfig` over the XDG path and will
  silently ignore the new location. Decide whether `install.sh` should detect
  and warn/remove a pre-existing `~/.gitconfig`, or just document the manual
  step.
- `$XDG_CONFIG_HOME` may be unset on some machines; needs a fallback to
  `~/.config` (matching git's own fallback behavior) rather than assuming the
  env var is always set.
- The referenced includes (`.common.gitconfig`, `~/.gitconfig.local`,
  `~/.gitconfig.personal`, `~/.gitconfig.work`) use absolute/home-relative
  paths already, so they shouldn't need changes — confirm this holds once the
  top-level file moves.

## Constraints

- Must keep working headlessly and on servers — see
  `dots/.gitconfig.local.example`'s existing warning about not putting
  machine/app-specific settings in `.common.gitconfig`.
- Should not require a manual one-time migration step on existing machines if
  avoidable, since this repo runs on multiple machines already provisioned
  with `~/.gitconfig`.
