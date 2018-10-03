alias ls='ls -FG'
alias ll='ls -lp'  # long list
alias l='ll -h'    # long list, human size
alias la='ll -A'   # long list, show almost all
alias lt='ll -t'   # long list, sorted by date, show type, human readable


alias d='docker'
alias dc='docker-compose'

alias r!="echo Reloading... && source $HOME/.zshrc"

alias bup='brew update && brew upgrade'

# https://github.com/chalk/supports-color/blob/711d47f3835c7297142e92ef5c71862394009c24/index.js#L68
# https://github.com/Marak/colors.js/blob/9f3ace44700b8e705cb15be4767845c311b3ae11/lib/system/supports-colors.js#L34
[[ $IS_CYGWIN ]] && alias gulp="FORCE_COLOR=on gulp --color=true"

# If nvim exists, hijack vim
if command -v nvim &> /dev/null; then
  alias vim=nvim
fi
