#!/bin/bash

cd /home/admin

# Hey, beware: avoid to add packages with X dependencies!
# No X on this machine!

sudo apt-get update
sudo apt-get -y install aptitude
sudo aptitude --assume-yes -Z install git
