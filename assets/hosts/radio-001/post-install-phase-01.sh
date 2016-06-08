#!/bin/sh

echo "create new user admin"
sleep 1
sudo adduser admin
sudo echo "admin ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo apt-get update
sudo apt-get -y install aptitude
sudo aptitude --assume-yes -Z install git gitk
sudo aptitude --assume-yes -Z install python3-flask
sudo aptitude --assume-yes -Z install build-essential
# flex & bison is required to build olsrd-v1
sudo aptitude --assume-yes -Z install bison flex
# who knows, better already installed
sudo aptitude --assume-yes -Z install gdb

git clone https://github.com/hgn/tr-olsrd-v1.git
cd tr-olsrd-v1
make build_all
sudo make install

