# Setup terminal, and turn on colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=ExFxcxdxbxegedabagacad

# Enable color in grep
# http://www.gnu.org/software/grep/manual/html_node/Environment-Variables.html
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='4;36'

# http://stackoverflow.com/a/2183920
# http://askubuntu.com/a/616615
export LESS='--quit-if-one-screen --no-init --ignore-case --raw-control-chars'
export PAGER='less'

export EDITOR=nano

# SET LANGUAGES
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
