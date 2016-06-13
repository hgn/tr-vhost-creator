#!/bin/bash

BRCTL_BIN="/sbin/brctl"
IP_BIN="/sbin/ip"

source $( dirname "${BASH_SOURCE[0]}" )/../assets/lib.sh

logfilepath=$(dirname "${BASH_SOURCE[0]}")/installation.log

function usage {
	echo -e "Usage:"
	echo -e "-c\tcreate topology"
	echo -e "-s\tstart whole topology"
	echo -e "-d\tdestroy topology"
	echo -e "-p\tstop topology"
	echo -e "-h\tusage (this screen)"
}


function destroy() {
	echo -e "Destroy Topology"

	# platform 01
	sudo lxc-stop --name "01t01"
	sudo lxc-stop --name "01r01"
	sleep 1s
	sudo lxc-destroy --name "01t01"
	sudo lxc-destroy --name "01r01"

	# platform 02
	sudo lxc-stop --name "02t01"
	sudo lxc-stop --name "02r01"
	sleep 1s
	sudo lxc-destroy --name "02t01"
	sudo lxc-destroy --name "02r01"

}

function create_bridges() {
	addBr br01r01t01
	addBr br01aFFr01

	addBr br02r01t01
	addBr br02aFFr01

	addBr brFFt01x01
}

function start() {
	echo -e "Start Topology"
	create_bridges

	sudo lxc-start -n "01t01" -d
	sudo lxc-start -n "01r01" -d

	sudo lxc-start -n "02t01" -d
	sudo lxc-start -n "02r01" -d

	# we sleed a litle bit, just that IP configuration
	# is settled a bit
	sleep 2
	sudo lxc-ls --fancy
}

function stop() {
	echo -e "Stop Topology"

	sudo lxc-stop -n "01t01"
	sudo lxc-stop -n "01r01"

	sudo lxc-stop -n "02t01"
	sudo lxc-stop -n "02r01"
}

function create() {
	clear
	cat $(dirname $(dirname "${BASH_SOURCE[0]}"))/assets/topology-create-message.txt
	echo -e "wait 10 seconds, CTRL-C to interrupt installation"
	sleep 10

	clear
	echo -e "Create Bridges"
	create_bridges

	# delete outdated logfiles and create file as
	# current user id, sudo'ed environments will
	# not help us
	rm -rf $logfilepath
	touch $logfilepath

	echo -e "Create Topology"
	echo -e "Create terminals"
	$(dirname "${BASH_SOURCE[0]}")/../guests/terminals/01t01/cmd.sh -n "01t01" -l $logfilepath
	$(dirname "${BASH_SOURCE[0]}")/../guests/terminals/02t01/cmd.sh -n "02t01" -l $logfilepath

	echo -e "Create routers"
	$(dirname "${BASH_SOURCE[0]}")/../guests/routers/01r01/cmd.sh -n "01r01" -l $logfilepath
	$(dirname "${BASH_SOURCE[0]}")/../guests/routers/02r01/cmd.sh -n "02r01" -l $logfilepath

	start
}

while getopts "csdhp" opt; do
  case $opt in
    c)
			create
			exit 0
    ;;
    s)
			start
			exit 0
    ;;
    p)
			stop
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
