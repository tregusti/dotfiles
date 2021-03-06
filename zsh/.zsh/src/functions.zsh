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


function flushdns() {
  sudo killall -HUP mDNSResponder
}

if [[ $IS_WSL ]]; then
  function pbpaste() {
    powershell.exe -noninteractive -noprofile -command Get-Clipboard
  }
  function pbcopy() {
    powershell.exe -noninteractive -noprofile -command 'echo $input | Set-Clipboard'
  }
fi
