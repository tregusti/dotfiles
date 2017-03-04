function take() {
  mkdir -p $1 && cd $1
}


function syntax() {
  if [[ -z `which highlight` ]]; then
    echo 'Maybe do a "brew install highlight"?'
    return
  fi

  highlight -S $1 -O ansi $2
}
