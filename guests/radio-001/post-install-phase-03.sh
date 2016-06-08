#!/bin/bash

SOURCE_DIR="src"


cd /home/admin
rm -rf $SOURCE_DIR
mkdir -p $SOURCE_DIR
cd $SOURCE_DIR

git clone https://github.com/hgn/tr-olsrd-v1.git
cd tr-olsrd-v1
make build_all
sudo make install
