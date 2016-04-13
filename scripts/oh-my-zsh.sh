#!/usr/bin/env bash

if hash zsh 2>/dev/null; then
    printf "\e[31m✔ oh-my-zsh is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing oh-my-zsh..."
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
printf "\e[31m✔ oh-my-zsh installed!"

