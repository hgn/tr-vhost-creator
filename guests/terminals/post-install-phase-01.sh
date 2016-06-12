#!/bin/sh

echo "create new user admin"
sleep 1
sudo useradd --create-home --shell /bin/bash --user-group admin
echo "admin:admin" | sudo chpasswd
sudo echo "admin ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
