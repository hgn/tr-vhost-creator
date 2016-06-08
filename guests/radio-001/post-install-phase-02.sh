#!/bin/bash

cd /home/admin

sudo apt-get update
sudo apt-get -y install aptitude
sudo aptitude --assume-yes -Z install git gitk
sudo aptitude --assume-yes -Z install python3-flask
sudo aptitude --assume-yes -Z install build-essential
# flex & bison is required to build olsrd-v1
sudo aptitude --assume-yes -Z install bison flex
# who knows, better already installed
sudo aptitude --assume-yes -Z install gdb
