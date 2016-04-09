#!/usr/bin/env bash

if [ -f '/usr/local/bin/composer' ]; then
	printf "\e[31m✔ composer is already installed, skipped installation..."
    exit 0;
fi;

printf "\e[31m installing composer..."
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
printf "\e[31m✔ composer installed!"