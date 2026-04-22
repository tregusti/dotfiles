# Test switches
# https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

local CURRENT_LOCALRC=""

autoload -U add-zsh-hook

load-localrc() {
  local RESET="\0033[0m"
  local RED="\033[31m"
  local GREEN="\033[32m"

  local PREFIX="localrc: "
  local localrc_path="$(find_localrc)"
  # echo "${PREFIX}Checking for localrc in $PWD"
  # echo "${PREFIX}Found: ${GREEN}${localrc_path:-None}${RESET}"

  # The "will be" active localrc is different from the currently active one, so we need to switch
  if [ "$CURRENT_LOCALRC" != "$localrc_path" ]; then
    # Execute the leave block for surrently loaded localrc
    if does_localrc_leave_exist; then
      echo "${PREFIX}Calling ${RED}localrc_leave${RESET} for $CURRENT_LOCALRC."
      localrc_leave
      # Remove the leave function to avoid accidentally calling it for the next localrc
      unset -f localrc_leave

    fi

    CURRENT_LOCALRC="$localrc_path"

    # Is there a new one to be activated?
    if [ -f "$localrc_path" ]; then
      echo "${PREFIX}Loading $localrc_path."
      source "${localrc_path}"

      # Execute the enter block for the newly loaded localrc
      if does_localrc_enter_exist; then
        echo "${PREFIX}Calling ${GREEN}localrc_enter${RESET} for $CURRENT_LOCALRC."
        localrc_enter
        # Remove the enter function to avoid accidentally calling it for the next localrc
        unset -f localrc_enter
      fi
    fi
  fi
}

find_localrc() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/.localrc" ]; then
      echo "$dir/.localrc"
      return
    fi
    dir=$(dirname "$dir")
  done
  return ""
}
does_localrc_enter_exist() {
  type 'localrc_enter' 2> /dev/null | grep -q 'function'
}
does_localrc_leave_exist() {
  type 'localrc_leave' 2> /dev/null | grep -q 'function'
}

add-zsh-hook chpwd load-localrc
load-localrc
