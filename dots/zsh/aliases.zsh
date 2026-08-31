alias ls='ls -FG'
alias ll='ls -lp'  # long list
alias l='ll -h'    # long list, human size
alias la='ll -A'   # long list, show almost all

if command -v eza &> /dev/null; then
  alias eza='eza --time-style=long-iso'
  alias e='eza -1'
  alias l='e --long --header --no-permissions --no-user'
  alias ll='e --long'
  alias la='e --long --all'
  alias lg='e --long --git'
  alias lt='e --long --tree --level=2'
  alias lc='e --code'
fi

alias cdc='cd ~/Dropbox/code/personal'

alias reload="echo Reloading... && source $HOME/.zshrc"

alias bup='brew update && brew upgrade'

# https://github.com/chalk/supports-color/blob/711d47f3835c7297142e92ef5c71862394009c24/index.js#L68
# https://github.com/Marak/colors.js/blob/9f3ace44700b8e705cb15be4767845c311b3ae11/lib/system/supports-colors.js#L34
[[ $IS_CYGWIN ]] && alias gulp="FORCE_COLOR=on gulp --color=true"

# If nvim exists, hijack vim
if command -v nvim &> /dev/null; then
  alias vim=nvim
fi
