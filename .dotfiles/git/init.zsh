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
  git config --global core.editor vim
  git config --global core.pager 'less -RFX -x1,5'
  git config --global color.diff auto
  git config --global color.status auto
  git config --global color.interactive auto
  git config --global color.branch auto
  # Better diff algorithm
  # https://github.com/blog/2188-git-2-9-has-been-released
  # https://blog.github.com/2016-11-29-git-2-11-has-been-released/#sundries
  # git config --global diff.indentHeuristic=true

  # For cygwin issues with singleKey
  # 1. https://github.com/transcode-open/apt-cyg
  # 2. apt-cyg install perl-TermReadKey
  git config --global interactive.singleKey true

  # Command defaults
  git config --global alias.log 'log --topo-order'
  git config --global alias.pull 'pull -p'

  # Pretty formats
  git config --global pretty.log '%C(yellow)%h%Creset %C(red)%cd%Creset %s%C(yellow)%d%Creset %C(red)(%an, %cr)%Creset'

  # Aliases
  git config --global alias.a     'add'
  git config --global alias.ap    'add -p'
  git config --global alias.b     'branch'
  git config --global alias.ba    'branch --all'
  git config --global alias.br    'branch --remote'
  git config --global alias.brmm  '! BRMM_BRANCH=$(git config --get custom.defaultBranch || echo master) && git branch --merged=$BRMM_BRANCH | cut -c3- | grep -v $BRMM_BRANCH | xargs git branch -d'
  git config --global alias.c     'commit -v'
  git config --global alias.ca    'commit -v -a'
  git config --global alias.cm    'commit -m'
  git config --global alias.cam   'commit -a -m'
  git config --global alias.co    'checkout'
  git config --global alias.cb    'checkout -b'
  git config --global alias.cp    'cherry-pick'
  git config --global alias.cpx   'cherry-pick -x'
  git config --global alias.d     'diff --color --ws-error-highlight=all'
  git config --global alias.db    '! git d $(git merge-base head $(git config --get custom.defaultBranch || echo master))'
  git config --global alias.dw    'diff --color --ws-error-highlight=all --color-words'
  git config --global alias.ds    'diff --color --ws-error-highlight=all --staged'
  git config --global alias.dsw   'diff --color --ws-error-highlight=all --staged --color-words'
  git config --global alias.f     'fetch -p'
  git config --global alias.h     'log --pretty=log --graph --date=short'
  git config --global alias.hb    '! git h $(git merge-base head $(git config --get custom.defaultBranch || echo master))..HEAD'
  git config --global alias.r     'rebase'
  git config --global alias.puff  'push --force-with-lease'
  git config --global alias.root  'rev-parse --show-toplevel'
  git config --global alias.s     'status -s'
  git config --global alias.serve '! git daemon --enable=receive-pack --reuseaddr --informative-errors --verbose  --base-path=. --export-all ./.git'
  git config --global alias.showw 'show --color-words'
  git config --global alias.m     'merge'
  git config --global alias.whois '! sh -c "git log -i -1 --pretty=\"format:%an <%ae>\" --author=\"$1\"" -'
  git config --global alias.find-merge '! git show-branch "$1" | cut -c 2-8'
  git config --global alias.show-merge '! git show `git find-merge $1`'

  rm -rf "$LOCK_FILE"
fi

unset LOCK_FILE

git-massage() {
  echo "Unstable. Seems to pop stash even when it didn't stash. Or something..."
  exit 1
  local stashed=$(test -z "$(git status --short --porcelain)")
  if $stashed; then
    git stash save --quiet --include-untracked 'autostash' && git rebase -i `git merge-base head master` && git stash pop
  else
    git rebase -i `git merge-base head master`
  fi
}

git-worklog() {
  local since=$1
  local author=${2:=glenn}

  if [[ -z "$since" ]]; then
    echo "Usage: $0 <from-iso-date> [<author-name>:glenn]"
    return
  fi

  git log --pretty=format:"%C(yellow)%ad%Creset %s%C(yellow)%d%Creset %C(red)(%an, commit: %cd)%Creset" --all --date=short --author="$author" --since="$since" | sort -g -r | less
}
