#!/usr/bin/env bash

if hash git 2>/dev/null; then
    printf "\e[31m✔ git is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing git..."
sudo yum -y install git
git config --global user.name $1
git config --global user.email $2
printf "\e[31m✔ git installed!"