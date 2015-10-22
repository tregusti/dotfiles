# 0 is true, all others are false (think exit codes)

if [[ $(uname) =~ linux ]]; then
  IS_LINUX=0
fi

if [[ $(uname) =~ darwin ]]; then
  IS_MAC=0
fi

if [[ $(uname) =~ cygwin_nt ]]; then
  IS_CYGWIN=0
fi
