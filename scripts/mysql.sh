#!/usr/bin/env bash

if hash mysql 2>/dev/null; then
    printf "\e[31m✔ mariadb is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m installing mariadb..."
sudo yum -y install mariadb-server mariadb
sudo systemctl enable mariadb
sudo systemctl start mariadb
mysql -uroot -e "CREATE DATABASE $3; CREATE USER '$1'@'localhost' IDENTIFIED BY '$2'; GRANT ALL PRIVILEGES ON * . * TO '$1'@'localhost'; FLUSH PRIVILEGES;"
printf "\e[31m✔ mariadb installed!"