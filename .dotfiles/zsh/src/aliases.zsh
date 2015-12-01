alias ls='ls -FG'
alias ll='ls -lp'  # long list
alias l='ll -h'    # long list, human size
alias la='ll -A'   # long list, show almost all
alias lt='ll -t'   # long list, sorted by date, show type, human readable


alias fd='find . -type d -name'
alias ff='find . -type f -name'


# https://github.com/chalk/supports-color/blob/711d47f3835c7297142e92ef5c71862394009c24/index.js#L68
[[ $IS_CYGWIN ]] && alias gulp="FORCE_COLOR=on gulp"
