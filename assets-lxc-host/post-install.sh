#!/bin/sh

echo "create new user admin"
sleep 1
sudo adduser admin
sudo echo "admin ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

sudo apt-get update
sudo apt-get install aptitude
sudo aptitude install git gitk
sudo aptitude install python3-flask
