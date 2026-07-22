# link <source> <target>
# Symlinks <source> to <target>. Parent directories of the target are created as
# needed (for XDG paths like ~/.config/nvim). Already-correct symlinks are
# reported and left alone. Anything else at target (a real file/dir, or a
# symlink pointing elsewhere) is left untouched (skipped), never overwritten.
link() {
  local file="$1"
  local target="$2"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$file" ]; then
    echo "Already linked '$target' -> '$file'."
    return
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Warning: '$target' already exists. Skipping '$file'."
    return
  fi
  mkdir -p "$(dirname "$target")"
  ln -s "$file" "$target" && echo "Linked '$file' to '$target'" || echo "Failed to link '$file' to '$target'"
}

# Neovim (XDG). The old classic-Vim config now lives in ../legacy and is not linked.
link ~/.dotfiles/dots/.config/nvim ~/.config/nvim
# Minimal bare-Vim fallback for servers that have vim but not nvim.
link ~/.dotfiles/dots/.vimrc ~/.vimrc

link ~/.dotfiles/dots/.gitconfig ~/.gitconfig
link ~/.dotfiles/dots/.gitignore ~/.gitignore

link ~/.dotfiles/dots/.zshrc ~/.zshrc
link ~/.dotfiles/dots/.zsh ~/.zsh

link ~/.dotfiles/dots/.spaceshiprc.zsh ~/.spaceshiprc.zsh

link ~/.dotfiles/dots/.nethackrc ~/.nethackrc

# See code-snippets/README.md.
link ~/.dotfiles/code-snippets ~/Library/Application\ Support/Code/User/snippets

echo "Installation complete! Please restart your terminal to apply the changes."
