#!/usr/bin/env bash

if hash mysql 2>/dev/null; then
    printf "\e[31m✔ mysql is already installed, skipped installation..."
    exit 0;
fi

printf "\e[31m -> installing mysql server (community edition)"
mysqlRootPass="$(pwmake 128)"
sudo yum localinstall -y https://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
sudo yum install -y mysql-community-server
printf "\e[31m -> starting mysql server (first run)"
sudo systemctl enable mysqld.service
sudo systemctl start mysqld.service
tempRootDBPass="`grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -n 1 | sed 's/.*root@localhost: //'`"
printf "\e[31m -> setting up new mysql server root password"
sudo systemctl stop mysqld.service
sudo rm -rf /var/lib/mysql/*logfile*
sudo wget -O /etc/my.cnf "https://raw.githubusercontent.com/oromedialab/extras/master/my.cnf"
sudo systemctl start mysqld.service
sudo mysqladmin -u root --password="$tempRootDBPass" password "$mysqlRootPass"
sudo mysql -u root --password="$mysqlRootPass" -e <<-EOSQL
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test; 
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'; 
    DELETE FROM mysql.user where user != 'mysql.sys'; 
    CREATE USER 'root'@'%' IDENTIFIED BY '${mysqlRootPass}';
    GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOSQL
sudo systemctl status mysqld.service
printf "\e[31m -> mysql server installation completed, root password: $mysqlRootPass"