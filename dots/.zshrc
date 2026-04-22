# Inspired by http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/

source $HOME/.zsh/misc_config.zsh

source $HOME/.zsh/completions.zsh
source $HOME/.zsh/zplug.zsh
source $HOME/.zsh/checks.zsh
source $HOME/.zsh/colors.zsh
source $HOME/.zsh/locals.zsh
source $HOME/.zsh/setopt.zsh
# source $HOME/.zsh/nvm-autoload.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/functions.zsh
# source $HOME/.zsh/prompt.zsh

####### Load nvm if present

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
