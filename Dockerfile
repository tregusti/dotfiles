FROM ubuntu:latest
ARG username=dotglenn
ARG shell=/bin/zsh
RUN \
    apt-get update && \
    apt-get -y install zsh tree stow git mercurial tmux vim neovim
RUN useradd -ms $shell dotglenn
VOLUME /home/$username/.dotfiles
USER $username
WORKDIR /home/$username
