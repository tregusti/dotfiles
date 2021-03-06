# Setup terminal, and turn on colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=ExFxcxdxbxegedabagacad
# Needed for X server (rel to xclip for tmux)
export DISPLAY=:0

# Use 4 spaced for tabs in CLI
tabs 4

# set vim mode in zsh
# https://reza.jelveh.me/2011/09/18/zsh-tmux-vi-mode-cursor
bindkey -v

# use cursor as indicator of vi mode
zle-keymap-select () {
  if [ $KEYMAP = vicmd ]; then
    if [[ $TMUX = '' ]]; then
      echo -ne "\033]12;Red\007"
    else
      printf '\033Ptmux;\033\033]12;red\007\033\\'
    fi
  else
    if [[ $TMUX = '' ]]; then
      echo -ne "\033]12;Grey\007"
    else
      printf '\033Ptmux;\033\033]12;grey\007\033\\'
    fi
  fi
}
zle-line-init () {
  zle -K viins
  echo -ne "\033]12;Grey\007"
}
zle -N zle-keymap-select
zle -N zle-line-init
# 10 ms timeout instead of the default 400
export KEYTIMEOUT=1

# Expose bins in dofiles
export PATH=$PATH:~/.dotfiles/bin

# Enable color in grep
# http://www.gnu.org/software/grep/manual/html_node/Environment-Variables.html
export GREP_COLOR='4;36'
alias grep='grep --color=auto'

# http://stackoverflow.com/a/2183920
# http://askubuntu.com/a/616615
export LESS='--quit-if-one-screen --no-init --ignore-case --chop-long-lines --raw-control-chars'
export PAGER='less'

export EDITOR=vim

# SET LANGUAGES
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
