
if [[ ! -f ~/.zsh/completions/_docker ]]; then
  if [[ $(command -v docker) && $(docker --version) ]]; then
    docker completion zsh > ~/.zsh/completions/_docker
  fi
fi

fpath=(~/.zsh/completions $fpath)

# compinit should be run after generating the completions.
# It is run by zplug.
