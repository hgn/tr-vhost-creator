#!/bin/bash

SOURCE_DIR="src/tactical-components"

if [ "$USER" != "admin" ]
	echo -e "Can only executed as user admin"
	exit
fi

cd $HOME
rm -rf $SOURCE_DIR
mkdir -p $SOURCE_DIR
cd $SOURCE_DIR

git clone https://github.com/hgn/tr-olsrd-v1.git
cd tr-olsrd-v1
make build_all
sudo make install

