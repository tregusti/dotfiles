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

selection=$(printf '%s\n' "${projects[@]}" | sed 's/:/: /' | fzf --reverse) || exit
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
