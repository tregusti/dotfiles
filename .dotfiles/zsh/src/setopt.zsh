# man zshoptions

# ===== Basics
setopt NO_BEEP # don't beep on error
setopt INTERACTIVE_COMMENTS # Allow comments even in interactive shells

# ===== Changing Directories
setopt AUTO_CD # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
# setopt CDABLEVARS # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt PUSHD_IGNORE_DUPS # don't push multiple copies of the same directory onto the directory stack

# ===== Completion
setopt ALWAYS_TO_END # When completing from the middle of a word, move the cursor to the end of the word
unsetopt MENU_COMPLETE # do not autoselect the first completion entry
setopt AUTO_MENU # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt COMPLETE_IN_WORD # Allow completion from within a word/phrase
setopt LIST_PACKED # Print the matches in columns with different widths.
setopt LIST_TYPES # Show the type of each file with a trailing identifying mark.

# ===== Prompt
setopt PROMPT_SUBST # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt TRANSIENT_RPROMPT # only show the rprompt on the current prompt

# ===== Correction
# setopt CORRECT_ALL # spelling correction for arguments
setopt CORRECT # spelling correction for commands


# # ===== Expansion and Globbing
# setopt EXTENDED_GLOB # treat #, ~, and ^ as part of patterns for filename generation
#
# ===== History
# setopt APPEND_HISTORY # Allow multiple terminal sessions to all append to one zsh command history
setopt EXTENDED_HISTORY # save timestamp of command and duration
setopt INC_APPEND_HISTORY # Add commands as they are typed, don't wait until shell exit
setopt HIST_EXPIRE_DUPS_FIRST # when trimming history, lose oldest duplicates first
setopt HIST_IGNORE_DUPS # Do not write events to history that are duplicates of previous events
# setopt HIST_IGNORE_SPACE # remove command line from history list when first character on the line is a space
setopt HIST_FIND_NO_DUPS # When searching history don't display results already cycled through twice
# setopt HIST_REDUCE_BLANKS # Remove extra blanks from each command line being added to history
setopt HIST_VERIFY # don't execute, just expand history
# setopt SHARE_HISTORY # imports new commands and appends typed commands to history


# ===== Scripts and Functions
# setopt MULTIOS # perform implicit tees or cats when multiple redirections are attempted
