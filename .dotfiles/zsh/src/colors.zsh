autoload colors; colors

# Create variables for colors to use in prompts
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
  eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
  eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
  eval export PR_$COLOR
  eval export PR_BOLD_$COLOR
done

eval RESET='$reset_color'
