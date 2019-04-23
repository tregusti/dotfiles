# Inspired by http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/

# Plugs via zplugs
export ZPLUG_HOME=~/.zplug
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

# zplug check returns true if all packages are installed
# Therefore, when it returns false, run zplug install
if ! zplug check; then
  zplug install
fi

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# cool prompt:
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme
export SPACESHIP_BATTERY_THRESHOLD=30


# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

source $HOME/.zsh/src/checks.zsh
source $HOME/.zsh/src/colors.zsh
source $HOME/.zsh/src/setopt.zsh
source $HOME/.zsh/src/misc_config.zsh
source $HOME/.zsh/src/plugins.zsh
source $HOME/.zsh/src/aliases.zsh
source $HOME/.zsh/src/functions.zsh
# source $HOME/.zsh/src/prompt.zsh

#### FUZZY FINDER
# https://github.com/junegunn/fzf#using-homebrew-or-linuxbrew
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# https://github.com/sharkdp/fd#on-macos
export FZF_COMPLETION_TRIGGER='..'
test ! -z "$(whence fd)" && export FZF_DEFAULT_COMMAND='fd'

# FZF_DEFAULT_OPTS=''


test -f $HOME/.localrc && source $HOME/.localrc
