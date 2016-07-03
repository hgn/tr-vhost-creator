#!/bin/bash

cd /home/admin

sudo apt-get update
sudo apt-get -y install aptitude
sudo aptitude --assume-yes -Z install git
