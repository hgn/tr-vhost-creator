#!/bin/bash

echo "${BASH_SOURCE[0]}"

source ./$( dirname "${BASH_SOURCE[0]}" )/../lib.sh

while getopts ":n:p:" opt; do
  case $opt in
    n) name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo -e "Generate Topology"

./$( dirname "${BASH_SOURCE[0]}" )/../hosts/radio-001/cmd.sh  -n "terminal01"
