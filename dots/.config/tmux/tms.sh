#!/usr/bin/env zsh
# Fuzzy-pick a project directory and create-or-attach a tmux session for it.
# Run as a script (not a zsh function loaded via `zsh -ic`) so tmux's
# display-popup doesn't have to bootstrap the whole interactive rc
# (zplug, spaceship prompt, fzf-tab, ...) just to get this one command.

# name:path pairs: dotfiles first, then every directory under
# ~/Dropbox/code/personal (picked up automatically, no hand-maintained list).
projects=(dotfiles:~/.dotfiles)
for dir in ~/Dropbox/code/personal/*(/); do
  projects+=("$(basename "$dir"):$dir")
done

# Running sessions float to the top, in the order above; everything else
# follows in that same order underneath.
project_names=("${projects[@]%%:*}")
session_pairs=(${(f)"$(tmux list-sessions -F '#S:#{session_path}' 2>/dev/null)"})
sessions=("${(@)session_pairs%%:*}")
active=()
inactive=()
for entry in "${projects[@]}"; do
  if (( ${sessions[(Ie)${entry%%:*}]} )); then
    active+=("$entry")
  else
    inactive+=("$entry")
  fi
done
# Open sessions with no matching project entry (e.g. attached outside the
# known project dirs) still get a picker row, using tmux's own record of
# their working directory.
extra=()
for pair in "${session_pairs[@]}"; do
  if (( ! ${project_names[(Ie)${pair%%:*}]} )); then
    extra+=("$pair")
  fi
done
projects=("${active[@]}" "${extra[@]}" "${inactive[@]}")

# Color active entries green so running sessions stand out, not just sort
# to the top; extra (unmatched) sessions get yellow instead, to mark them
# as running but outside the known project list. --ansi tells fzf to
# render the color codes instead of matching/displaying them literally.
green=$'\033[32m'
yellow=$'\033[33m'
dim=$'\033[2m'
reset=$'\033[0m'
lines=()
for entry in "${active[@]}"; do
  lines+=("${green}${entry%%:*}${reset}: ${dim}${entry#*:}${reset}")
done
for entry in "${extra[@]}"; do
  lines+=("${yellow}${entry%%:*}${reset}: ${dim}${entry#*:}${reset}")
done
for entry in "${inactive[@]}"; do
  lines+=("${entry%%:*}: ${dim}${entry#*:}${reset}")
done

selection=$(printf '%s\n' "${lines[@]}" | fzf --ansi --reverse) || exit
selection=$(print -r -- "$selection" | sed $'s/\033\[[0-9;]*m//g')
name=${selection%%:*}
dir=${selection#*: }
# has-session + plain new-session, not `-A -d`: `-A` only stays detached
# the first time a session is created — on an existing session it silently
# drops `-d` and attaches right here, inside the popup's own pty.
tmux has-session -t "$name" 2>/dev/null || tmux new-session -d -s "$name" -c "$dir"
if [ -n "$TMUX" ]; then
  tmux switch-client -t "$name"
else
  tmux attach -t "$name"
fi
