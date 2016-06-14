#!/bin/bash

cd /home/admin

# Hey, beware: avoid to add packages with X dependencies!
# No X on this machine!

sudo apt-get update
sudo apt-get -y install aptitude
sudo aptitude --assume-yes -Z install git tcpdump
sudo aptitude --assume-yes -Z install python3-flask
sudo aptitude --assume-yes -Z install build-essential

# network daemons
# NOTE: configuration files must be copied earlier in the process
sudo aptitude --assume-yes -Z install smcroute
sudo systemctl enable smcroute
sudo systemctl start smcroute

# flex & bison is required to build olsrd-v1
sudo aptitude --assume-yes -Z install bison flex

# who knows, better already installed
sudo aptitude --assume-yes -Z install gdb
