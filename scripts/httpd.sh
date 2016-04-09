#!/usr/bin/env bash

if hash httpd 2>/dev/null; then
    printf "\e[31m✔ httpd is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing httpd..."
sudo yum -y install httpd
sudo systemctl start httpd.service
sudo systemctl restart httpd.service
sudo systemctl enable httpd.service
printf "\e[31m✔ httpd installed!"