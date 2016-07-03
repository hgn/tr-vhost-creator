#!/bin/bash

SOURCE_DIR="src"


cd /home/admin

git clone https://github.com/hgn/tr-bootstrapper.git
cd tr-bootstrapper
python3 bootstrap.py -vvv

# script is executed via lxc-attach and thus the owner
# must be corrected
#chown -R admin:admin /home/admin
