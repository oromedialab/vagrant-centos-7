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
# Start/restart apache
sudo systemctl start httpd.service
sudo systemctl restart httpd.service