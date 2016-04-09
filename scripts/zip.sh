#!/usr/bin/env bash

if hash zip 2>/dev/null; then
    printf "\e[31m✔ zip is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing zip..."
sudo yum -y install zip
sudo yum -y install unzip
printf "\e[31m✔ zip installed!"