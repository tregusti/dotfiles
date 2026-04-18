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

link ~/.dotfiles/vim/.vim
link ~/.dotfiles/vim/.vimrc

link ~/.dotfiles/git/.gitconfig
link ~/.dotfiles/git/.gitignore

link ~/.dotfiles/zsh/.zshrc
link ~/.dotfiles/zsh/.zsh

echo "Installation complete! Please restart your terminal to apply the changes."
