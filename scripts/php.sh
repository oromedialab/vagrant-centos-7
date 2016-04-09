#!/usr/bin/env bash

if hash php 2>/dev/null; then
    printf "\e[31m✔ PHP is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing PHP..."
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum -y install php70w
sudo yum -y install php70w-common
sudo yum -y install php70w-mysql
sudo yum -y install php70w-intl
sudo yum -y install php70w-mbstring
sudo yum -y install php70w-mcrypt

printf "\e[31m✔ PHP installed!"