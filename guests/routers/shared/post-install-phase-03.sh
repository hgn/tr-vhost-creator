#!/bin/bash

SOURCE_DIR="src"


cd /home/admin
rm -rf $SOURCE_DIR
mkdir -p $SOURCE_DIR
cd $SOURCE_DIR

# install handy helper programs
git clone https://github.com/hgn/mcast-discovery-daemon.git
git clone https://github.com/hgn/ipproof.git


git clone https://github.com/hgn/tr-olsrd-v1.git
cd tr-olsrd-v1
make build_all
sudo make install_all

# script is executed via lxc-attach and thus the owner
# must be corrected
chown -R admin:admin /home/admin/$SOURCE_DIR
