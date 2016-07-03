#!/bin/bash

cd /home/admin

git clone https://github.com/hgn/tr-bootstrapper.git
cd tr-bootstrapper
python3 bootstrap.py -vvv

