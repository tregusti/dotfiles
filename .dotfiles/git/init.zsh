alias git='LC_ALL=en_GB git'

[[ `git config --get user.name` ]]  || echo 'No user name set for git.'
[[ `git config --get user.email` ]] || echo 'No user email set for git.'

LOCK_FILE="$HOME/.gitconfig.customlock"

if [[ ! -f "$LOCK_FILE" ]]; then
  touch "$LOCK_FILE"

  # Config
  git config --global rerere.enabled true
  git config --global pull.rebase true
  git config --global pull.ff only
  git config --global merge.conflictstyle diff3
  git config --global color.diff auto
  git config --global color.status auto
  git config --global color.interactive auto
  git config --global color.branch auto

  # Command defaults
  git config --global alias.log 'log --topo-order'
  git config --global alias.pull 'pull -p'

  # Aliases
  git config --global alias.a    'add'
  git config --global alias.ap   'add -p'
  git config --global alias.b    'branch'
  git config --global alias.ba   'branch --all'
  git config --global alias.br   'branch --remote'
  git config --global alias.brmm '! git branch --merged=master | cut -c3- | grep -v master | xargs git branch -d'
  git config --global alias.c    'commit -v'
  git config --global alias.ca   'commit -v -a'
  git config --global alias.cm   'commit -m'
  git config --global alias.cam  'commit -a -m'
  git config --global alias.co   'checkout'
  git config --global alias.cb   'checkout -b'
  git config --global alias.cp   'cherry-pick'
  git config --global alias.cpx  'cherry-pick -x'
  git config --global alias.d    'diff'
  git config --global alias.ds   'diff --staged'
  git config --global alias.f    'fetch -p'
  git config --global alias.h    'log --pretty=format:"%C(yellow)%h%Creset %cd | %s%C(yellow)%d%Creset %C(red)(%an, %cr)%Creset" --graph --date=short'
  git config --global alias.hb   '! git h `git merge-base head master`..HEAD'
  git config --global alias.r    'rebase'
  git config --global alias.s    'status -s'
  git config --global alias.m    'merge'

  rm -rf "$LOCK_FILE"
fi

unset LOCK_FILE
