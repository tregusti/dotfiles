# macOS specific configuration
# https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/issues/66

# Copy
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
bind-key -T copy-mode-vi 'V' send-keys -X select-line
bind-key -T copy-mode-vi 'r' send-keys -X rectangle-toggle
bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

# Paste
bind-key C-] run-shell 'pbpaste'
