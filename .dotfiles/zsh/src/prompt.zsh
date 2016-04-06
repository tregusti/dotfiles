# UTILS

short() {
  # Must be 8 chars or longer to match
  echo $1 | sed -E -e 's/^(...)..+(...)$/\1…\2/'
}

# GIT SETUP

if [[ -n $(which git) ]]; then
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWCOLORHINTS=
  GIT_PS1_DESCRIBE_STYLE="branch"
  GIT_PS1_SHOWUPSTREAM="auto git"

  # source $(git --exec-path)/../../etc/bash_completion.d/git-prompt.sh
fi

echo
echo Git prompt needs fixing.
echo

# PROMPT PARTS

last_exit_code() {
  print -n "%(?;;$PR_RED%?$PR_RESET by )"
}

git_prompt() {
  # Somewhere inside a git repo?
  [[ $(git rev-parse --git-dir --is-inside-git-dir \
    --is-bare-repository --is-inside-work-tree \
      --short HEAD 2>/dev/null) =~ 'true' ]] || return
  # Have helper function?
  # type __git_ps1 2>&1 > /dev/null || return


  local ref=$(command git symbolic-ref HEAD 2> /dev/null | sed 's,refs/heads/,,') || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return

  print -n ' on '
  print -n $PR_RED$ref$PR_RESET
}

current_time() {
  print -n $PR_YELLOW$(date '+%H:%M:%S')$PR_RESET
}

current_user() {
  print -n $PR_GREEN$(id -un)$PR_RESET
}

current_dir() {
  # Utils with enhanced extended regexps on OSX: http://stackoverflow.com/a/23146221
  local DIR="$(pwd)"

  # Replace HOME with ~
  DIR="$(echo $DIR | sed -e "s#^$HOME#~#")"

  # Simpler separator (newline)
  DIR="$(echo $DIR | tr '/' '\n')"

  # Define as array
  local -a PARTS
  # Split into array with newline (http://stackoverflow.com/a/2930519)
  PARTS=("${(@f)DIR}")
  # Reverse (http://www.zsh.org/mla/workers/2003/msg00413.html)
  PARTS=("${(@Oa)PARTS}")

  local PART1="${PARTS[1]}"
  local PART2="${PARTS[2]}"
  local PART3="${PARTS[3]}"

  # Concat parts if not empty
  DIR="$PART1"
  [ ! -z $PART2 ] && DIR="$(short $PART2)/$DIR"
  [ ! -z $PART3 ] && DIR="$(short $PART3)/$DIR"

  print -n "$PR_BLUE$DIR$PR_RESET"
}

# PROMPT DEFINITION

export PROMPT='$(last_exit_code)$(current_user) in $(current_dir)$(git_prompt) %# '
# export PROMPT='$(current_user)$(last_exit_code) at $(current_time) in $(current_dir) %# '
export SPROMPT='zsh: Correct %F{red}%R%f to %F{green}%r%f [nyae]? '

