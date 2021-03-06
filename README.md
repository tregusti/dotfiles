# My dotfiles

## Prerequisites

```
git
stow
```

Install with `brew` or `apt-get` or something similar.

## Install

```sh
git clone --recurse-submodules https://github.com/tregusti/dotfiles ~/.dotfiles
```

`.dotfiles` location is mandatory for now.

Then to enable the dotties, use [`stow`](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/) like this:

```sh
cd ~/.dotfiles
# All configs, last slash is important to only target directories
stow */
# Some specific config
stow git
```

## Installing brews

Install `brew` as per: https://brew.sh/

Then:

```sh
brew bundle

# core packages
brew bundle --file=core.brewfile
# optionally for my primary machine (or something, this needs to be structured better)
brew bundle --file=personal.brewfile
```

## TouchBar

Due to this incredibly stupid thing, I have learned off with using the REAL Escape key,
and instead using Ctrl-C in combination with single touch of [Ctrl that is remapped to
Escape with Karabiner](https://www.codeography.com/2017/07/16/the-next-era-of-remapping-caps-lock.html).

## Cygwin

Should work ok.

## Using WSL in Ubuntu on Windows

To get the colors correct (solarized), read more on [reddit](https://www.reddit.com/r/bashonubuntuonwindows/comments/60da1u/solarized_colors_for_vim_in_bash_on_windows_works/).

Use the fork mentioned since the original didn't work for me:

[pedrosans/cmd-colors-solarized](https://github.com/pedrosans/cmd-colors-solarized)

But please update git, tmux and vim.

### git

```sh
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git
```

From: https://askubuntu.com/a/568596

### tmux

```sh
sudo apt-get install gcc make libncurses5-dev libevent2-dev
# download latest release from https://github.com/tmux/tmux/releases
tar -xzf tmux-X.X.tar.gz
cd tmux-X.X
./configure && make
sudo make install
```

From: https://github.com/tmux/tmux

### vim

```sh
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim
```

From: http://tipsonubuntu.com/2016/09/13/vim-8-0-released-install-ubuntu-16-04/

## Thanks

Inspiration for this dotfiles repo has been taken from:

- https://github.com/alexpearce/dotfiles
- https://github.com/zanshin/dotfiles
- http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/
- https://github.com/joakimkarlsson/dotfiles
