#!/usr/bin/env bash

if hash puppet 2>/dev/null; then
    printf "\e[31m✔ puppet is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing puppet..."
sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
sudo yum -y install puppet
printf "\e[31m✔ puppet installed!"