#!/bin/bash


if [ "$USER" != "admin" ]
	echo -e "Can only executed as user admin"
	exit
fi

cd $HOME

sudo apt-get update
sudo apt-get install aptitude
sudo aptitude install git gitk
sudo aptitude install python3-flask
sudo aptitude install build-essential
# flex & bison is required to build olsrd-v1
sudo aptitude install bison flex
# who knows, better already installed
sudo aptitude install gdb

