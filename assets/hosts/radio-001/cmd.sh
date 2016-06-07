#!/bin/bash

source ./$( dirname "${BASH_SOURCE[0]}" )/../../lib.sh

name=$(randomString 10)
distribution=ubuntu

while getopts ":n:p:" opt; do
  case $opt in
    n) name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo -e "Generate image"
echo -e "  Name:         $name"
echo -e "  Distribution: $distribution"

sudo LANG=C LC_ALL=C lxc-create -f lxc-config -n $name -t $distribution
