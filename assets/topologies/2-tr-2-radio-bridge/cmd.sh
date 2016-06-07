#!/bin/bash

echo "${BASH_SOURCE[0]}"

source ./$( dirname "${BASH_SOURCE[0]}" )/../../lib.sh

function usage {
	echo -e "usage"
}

function create {
	echo -e "Create Topology"
	./$( dirname "${BASH_SOURCE[0]}" )/../../hosts/radio-001/cmd.sh  -n "terminal01"
}

while getopts "ch" opt; do
  case $opt in
    c)
			create
    ;;
    h)
			usage
		;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

