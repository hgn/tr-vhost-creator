#!/bin/sh

echo "create new user admin"
sleep 1
sudo adduser admin
sudo echo "admin ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo apt-get update
sudo apt-get install aptitude
sudo aptitude install git gitk
sudo aptitude install python3-flask
sudo aptitude install build-essential
# flex & bison is required to build olsrd-v1
sudo aptitude install bison flex
# who knows, better already installed
sudo aptitude install gdb

git clone https://github.com/hgn/tr-olsrd-v1.git
cd tr-olsrd-v1
make build_all
sudo make install

