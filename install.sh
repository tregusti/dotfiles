link() {
  local file="$1"
  local basename=$(basename "$file")
  local target="$HOME/$basename"
  if [ -e "$target" ]; then
    echo "Warning: '$target' already exists. Skipping '$file'."
    return
  fi
  ln -s "$file" "$target" && echo "Linked '$file' to '$target'" || echo "Failed to link '$file' to '$target'"
}

link ~/.dotfiles/dots/.vim
link ~/.dotfiles/dots/.vimrc

link ~/.dotfiles/dots/.gitconfig
link ~/.dotfiles/dots/.gitignore

link ~/.dotfiles/dots/.zshrc
link ~/.dotfiles/dots/.zsh

link ~/.dotfiles/dots/.spaceshiprc.zsh

link ~/.dotfiles/dots/.nethackrc

echo "Installation complete! Please restart your terminal to apply the changes."
