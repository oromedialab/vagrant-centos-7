#!/usr/bin/env bash

if hash httpd 2>/dev/null; then
    printf "\e[31m✔ httpd is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing httpd..."
sudo yum -y install httpd
printf "\e[31m✔ httpd installed!"