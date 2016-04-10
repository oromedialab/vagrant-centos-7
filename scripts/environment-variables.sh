#!/usr/bin/env bash

if ! grep -q "$1='$2'" "/home/vagrant/.bash_profile"; then
	printf "\e[31m setting environment variable [export $1='$2']\n"
	echo "export $1='$2'" >> /home/vagrant/.bash_profile
	source ~/.bash_profile
fi