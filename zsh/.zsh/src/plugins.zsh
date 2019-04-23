source $HOME/.dotfiles/zsh/vendor/zsh-completions/zsh-completions.plugin.zsh
autoload -U compinit && compinit

### History search
source $HOME/.dotfiles/zsh/vendor/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh

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
