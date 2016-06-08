#!/bin/bash

BRCTL_BIN="/sbin/brctl"
IP_BIN="/sbin/ip"

source $( dirname "${BASH_SOURCE[0]}" )/../assets/lib.sh

logfilepath=$(dirname "${BASH_SOURCE[0]}")/guests.log

function usage {
	echo -e "Usage:"
	echo -e "-c\tcreate topology"
	echo -e "-s\tstart whole topology"
	echo -e "-d\tdestroy topology"
	echo -e "-h\tusage (this screen)"
}


function destroy() {
	echo -e "Destroy Topology"
	sudo lxc-stop --name "terminal01"
	sleep 1s
	sudo lxc-destroy --name "terminal01"
}

function create_bridges() {
	addBr lxcbr5
}

function start() {
	echo -e "Start Topology"
	create_bridges
}

function create() {
	echo -e "Create Topology"
	create_bridges
	$(dirname "${BASH_SOURCE[0]}")/../guests/radio-001/cmd.sh  -n "terminal01" -l $logfilepath
}

while getopts "csdh" opt; do
  case $opt in
    c)
			create
			exit 0
    ;;
    c)
			start
			exit 0
    ;;
    d)
			destroy
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
