# 0 is true, all others are false (think exit codes)

if [[ $(uname) =~ linux ]]; then
  export IS_LINUX=0
fi

if [[ $(uname) =~ darwin ]]; then
  export IS_MAC=0
fi

if [[ $(uname) =~ cygwin_nt ]]; then
  export IS_CYGWIN=0
fi
