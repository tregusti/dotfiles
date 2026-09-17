#!/usr/bin/env bash

# link <source> <target>
# Symlinks <source> to <target>. Parent directories of the target are created as
# needed (for XDG paths like ~/.config/nvim). Already-correct symlinks are
# reported and left alone. Anything else at target (a real file/dir, or a
# symlink pointing elsewhere) is left untouched (skipped), never overwritten.
link() {
  local black="\x1b[30m"
  local red="\x1b[31m"
  local green="\x1b[32m"
  local yellow="\x1b[33m"
  local blue="\x1b[34m"
  local magenta="\x1b[35m"
  local cyan="\x1b[36m"
  local white="\x1b[37m"
  local dim="\x1b[2m"
  local reset="\x1b[0m"

  local file="$1"
  local target="$2"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$file" ]; then
    echo -e "${dim}Already linked '$target' -> '$file'.$reset"
    return
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo -e "${yellow}Warning: '$target' already exists. Skipping '$file'.$reset"
    return
  fi
  mkdir -p "$(dirname "$target")"
  ln -s "$file" "$target" &&
    echo -e "${green}Linked '$file' to '$target'$reset" ||
    echo -e "${red}Failed to link '$file' to '$target'$reset"
}

# Neovim (XDG). The old classic-Vim config now lives in ../legacy and is not linked.
link ~/.dotfiles/dots/config/nvim ~/.config/nvim
# Minimal bare-Vim fallback for servers that have vim but not nvim.
link ~/.dotfiles/dots/vimrc ~/.vimrc

link ~/.dotfiles/dots/config/git ~/.config/git

link ~/.dotfiles/dots/config/flameshot ~/.config/flameshot

link ~/.dotfiles/dots/config/tmux ~/.config/tmux

link ~/.dotfiles/dots/zshrc ~/.zshrc
link ~/.dotfiles/dots/zsh ~/.zsh

link ~/.dotfiles/dots/spaceshiprc.zsh ~/.spaceshiprc.zsh

link ~/.dotfiles/dots/nethackrc ~/.nethackrc

link ~/.dotfiles/dots/config/ghostty ~/.config/ghostty

link ~/.dotfiles/dots/config/hammerspoon ~/.hammerspoon

# See code-snippets/README.md.
link ~/.dotfiles/code-snippets ~/Library/Application\ Support/Code/User/snippets

echo "Installation complete! Please restart your terminal to apply the changes."
