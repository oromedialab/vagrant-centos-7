#!/usr/bin/env bash

if hash wget 2>/dev/null; then
    printf "\e[31m✔ wget is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing wget..."
sudo yum -y install wget
printf "\e[31m✔ wget installed!"