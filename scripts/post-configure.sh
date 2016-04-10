#!/usr/bin/env bash

# Disable SELINUX
sudo setenforce 0
sudo sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config

# Change Apache DOCUMENT_ROOT and restart apache
sudo mkdir -p $1
sudo sed -i $"s#DocumentRoot \"/var/www/html\"#DocumentRoot \"$1\"#g" /etc/httpd/conf/httpd.conf

# Enable PHP Errors
sudo sed -i $"s#display_errors = Off#display_errors = On#g" /etc/php.ini
sudo sed -i $"s#display_startup_errors = Off#display_startup_errors = On#g" /etc/php.ini

# Change Apache User & Group
sudo sed -i $"s#User apache#User $2#g" /etc/httpd/conf/httpd.conf
sudo sed -i $"s#Group apache#Group $2#g" /etc/httpd/conf/httpd.conf

# Change AllowOverride None to AllowOverride All in httpd.conf
sudo sed -i $"s#AllowOverride None#AllowOverride All#g" /etc/httpd/conf/httpd.conf

# Start/restart apache
sudo systemctl start httpd.service
sudo systemctl restart httpd.service