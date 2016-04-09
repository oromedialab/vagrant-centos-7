#!/usr/bin/env bash

# Set Language
localectl set-locale LANG=en_US.utf8

# Update repositores
sudo yum update
sudo yum -y install epel-release
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm