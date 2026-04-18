# Plugs via zplugs

if [ ! -f ~/.zplug/init.zsh ]; then
  # https://github.com/zplug/zplug/blob/main/README.md#installation
  export ZPLUG_HOME=~/.zplug
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

source ~/.zplug/init.zsh

########### PLUGINS START ###########

# ========= Add zplug itself (for handling updates)
# For now, comment this out, due to: https://github.com/zplug/zplug/issues/467
# zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Update zplug with git commands manually
# Subshell to avoid affecting the current shell's working directory
# Silence stdout 1 (e.g. "Updating 1234567..89abcde")
# Silence stderr 2 (e.g. "Already up to date.")
( cd ~/.zplug && git pull origin main > /dev/null 2>&1 )

# ========= Add cool prompt
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

# ========= Add syntax highlighting
zplug "zsh-users/zsh-syntax-highlighting", as:plugin

# ========= Add autosuggestions
zplug "zsh-users/zsh-autosuggestions", as:plugin

# ========= Add tzf-tab
# https://github.com/aloxaf/fzf-tab#install
zplug "Aloxaf/fzf-tab", as:plugin

# Ensure colors match by using FZF_DEFAULT_OPTS
zstyle ":fzf-tab:*" use-fzf-default-opts yes

# ========= History search with UP and DOWN arrow keys and Ctrl+r
zplug "zsh-users/zsh-history-substring-search", as:plugin

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
if ! zplug check; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load
