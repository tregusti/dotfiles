# My dotfiles

## Prerequisites

```
git
```

Install with `brew` or `apt-get` or something similar.

## Install

```sh
git clone https://github.com/tregusti/dotfiles ~/.dotfiles
```

`~/.dotfiles` location is mandatory for now.

```sh
cd ~/.dotfiles
./install.sh
```

## git

`~/.gitconfig` is a wrapper that includes `dots/common.gitconfig`. It also
includes:

- `~/.gitconfig.local` if present.
- `~/.gitconfig.work` if in a work repo
- `~/.gitconfig.personal` if in a personal repo

See [`.gitconfig`](dots/.gitconfig) for details.

## SSH

SSH keys are solely managed by 1Password. Setup `~/.ssh/config` to point at the
1Password agent, which holds the private keys and signs on demand:

```
Host *
  IdentityAgent "~/Library/Group Containers/<XXXXXXX>.com.1password/t/agent.sock"
```

On a new machine:

1. Enable the 1Password SSH agent (Settings → Developer → SSH Agent).
2. Create a new per-machine key **in** 1Password (one key per machine, clearly named).
3. Add its public key to GitHub as an Authentication key (and a Signing key, if signing).
