#!/usr/bin/env bash
# This bootstraps Puppet on CentOS 7.x, It has been tested on CentOS 7 64bit

# function to check if a command exist
exists() {
  command -v "$1" >/dev/null 2>&1
}
# Set Language
localectl set-locale LANG=en_US.utf8

# Update yum
sudo yum update
if exists mysql; then
	echo "mysql is already installed!"
else
	mysqlRootPass="$(pwmake 128)"

	echo ' -> Installing mysql server (community edition)'
	yum localinstall -y https://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
	yum install -y mysql-community-server

	echo ' -> Starting mysql server (first run)'
	systemctl enable mysqld.service
	systemctl start mysqld.service
	tempRootDBPass="`grep 'temporary.*root@localhost' /var/log/mysqld.log | tail -n 1 | sed 's/.*root@localhost: //'`"

	echo ' -> Setting up new mysql server root password'
	systemctl stop mysqld.service
	rm -rf /var/lib/mysql/*logfile*
	wget -O /etc/my.cnf "https://my-site.com/downloads/mysql/512MB.cnf"
	systemctl start mysqld.service
	mysqladmin -u root --password="$tempRootDBPass" password "$mysqlRootPass"
	mysql -u root --password="$mysqlRootPass" -e <<-EOSQL
	    DELETE FROM mysql.user WHERE User='';
	    DROP DATABASE IF EXISTS test; 
	    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'; 
	    DELETE FROM mysql.user where user != 'mysql.sys'; 
	    CREATE USER 'root'@'%' IDENTIFIED BY '${mysqlRootPass}';
	    GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
	    FLUSH PRIVILEGES;
	EOSQL
	systemctl status mysqld.service
	echo " -> MySQL server installation completed, root password: $mysqlRootPass";
fi
# php (v7 - latest)
if exists php; then
	echo "php is already installed!"
else
	echo "updating php package repository..."
	sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
	echo "php package repository update!"
	echo "installing php..."
	sudo yum -y install php70w
	echo "php installed..."	
fi
# apache
if exists httpd; then
	echo "apache is already installed!"
else
	echo "installing apache..."
	sudo yum -y install httpd
	echo "apache installed..."
fi
# config
if exists httpd; then
	echo "updating config..."
	setenforce 0
	sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config
	sudo systemctl start httpd.service
	sudo systemctl restart httpd.service
	sudo systemctl enable httpd.service
	echo "config updated!"
fi;
# wget
if exists wget; then
	echo "wget is already installed!"
else
	echo "installing wget..."
	sudo yum -y install wget
	echo "wget installed!"
fi
# puppet
if exists puppet; then
	echo "puppet is already installed"
else
	echo "installing puppet..."
	sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
	sudo yum -y install puppet
	echo "puppet installed!"
fi
# puppet modules
echo "installing puppet modules..."
puppet module install puppetlabs-git
puppet module install willdurand-composer
echo "puppet modules installed!"