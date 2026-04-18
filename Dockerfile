# syntax=docker/dockerfile:1

FROM node:24.14.1-bookworm AS deps
WORKDIR /app

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        locales-all \
        git \
        less \
        vim \
        zsh \
        gawk \
        fzf \
    && rm -rf /var/lib/apt/lists/*

COPY . /root/.dotfiles
RUN cd /root/.dotfiles && ./install.sh

CMD ["zsh"]
