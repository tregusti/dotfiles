# Linux specific configuration
# http://www.rushiagr.com/blog/2016/06/16/everything-you-need-to-know-about-tmux-copy-pasting-ubuntu/

# Here we are using the defined function for pasteboard for WSL systems.
# See .dotfiles/zsh/src/function.zsh file

# Copy
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
bind-key -T copy-mode-vi 'V' send-keys -X select-line
bind-key -T copy-mode-vi 'r' send-keys -X rectangle-toggle
bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "split-window"

# Paste
bind-key ] run-shell 'pbpaste | tmux load-buffer -' \; paste-buffer
