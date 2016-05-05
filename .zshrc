# Inspired by http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/

source $HOME/.dotfiles/zsh/src/checks.zsh
source $HOME/.dotfiles/zsh/src/colors.zsh
source $HOME/.dotfiles/zsh/src/setopt.zsh
source $HOME/.dotfiles/zsh/src/misc_config.zsh
source $HOME/.dotfiles/zsh/src/plugins.zsh
source $HOME/.dotfiles/zsh/src/aliases.zsh
source $HOME/.dotfiles/zsh/src/functions.zsh
source $HOME/.dotfiles/zsh/src/prompt.zsh
source $HOME/.dotfiles/zsh/src/vi-mode.zsh

source $HOME/.dotfiles/git/init.zsh
source $HOME/.dotfiles/nvm/init.zsh

test -f $HOME/.localrc && source $HOME/.localrc
