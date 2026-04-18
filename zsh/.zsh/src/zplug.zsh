if [ ! -f ~/.zplug/init.zsh ]; then
  # Plugs via zplugs
  # https://github.com/zplug/zplug/blob/main/README.md#installation
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  echo "Awaiting zplug installation..."
  sleep 1
fi

source ~/.zplug/init.zsh

# zplug check returns true if all packages are installed
# Therefore, when it returns false, run zplug install
if ! zplug check; then
  zplug install
fi
########### PLUGINS START ###########

# ========= Add cool prompt
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme
export SPACESHIP_BATTERY_THRESHOLD=30

# ========= History search with UP and DOWN arrow keys and Ctrl+r
zplug "zsh-users/zsh-history-substring-search", as: plugin

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind k and j for navigating hostory
# k and j conflicts with tmux/vim pane nav, so use p and n.
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

bindkey '^r' history-incremental-search-backward


########### PLUGINS END ###########

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load
