#!/usr/bin/env bash

if hash git 2>/dev/null; then
    printf "\e[31m✔ git is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing git..."
sudo yum -y install git
printf "\e[31m✔ git installed!"