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

	sudo lxc-stop --name "01t01"
	sleep 1s
	sudo lxc-destroy --name "01t01"

	sudo lxc-stop --name "02t01"
	sleep 1s
	sudo lxc-destroy --name "02t01"
}

function create_bridges() {
	addBr br01r01t01
	addBr br02r01t01
	addBr brFFt01x01
}

function start() {
	echo -e "Start Topology"
	create_bridges

	sudo lxc-start -n "01t01" -d
	sudo lxc-start -n "02t01" -d

	sudo lxc-ls --fancy
}

function create() {
	echo -e "Create Topology"
	create_bridges
	$(dirname "${BASH_SOURCE[0]}")/../guests/terminals/01t01/cmd.sh -n "01t01" -l $logfilepath
	$(dirname "${BASH_SOURCE[0]}")/../guests/terminals/02t01/cmd.sh -n "02t01" -l $logfilepath

	start
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
