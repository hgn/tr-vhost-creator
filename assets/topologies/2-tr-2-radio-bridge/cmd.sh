#!/bin/bash

source ./$( dirname "${BASH_SOURCE[0]}" )/../../lib.sh

function usage {
	echo -e "Usage:"
	echo -e "-c\tcreate topology"
	echo -e "-h\tusage (this screen)"
}

function create {
	echo -e "Create Topology"
	./$( dirname "${BASH_SOURCE[0]}" )/../../hosts/radio-001/cmd.sh  -n "terminal01"
}

while getopts "ch" opt; do
  case $opt in
    c)
			create
			exit 0
    ;;
    h)
			usage
			exit 0
		;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

usage
exit 1
