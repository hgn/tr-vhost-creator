#!/bin/bash

BRCTL_BIN="/sbin/brctl"
IP_BIN="/sbin/ip"

exec 10<>/dev/tty

source $( dirname "${BASH_SOURCE[0]}" )/../assets/lib.sh

logfilepath=$(dirname "${BASH_SOURCE[0]}")/installation.log

function enable_silent_mode_with_log()
{
	exec > ${logfilepath} 2>&1
}

function usage {
	echo -e "Usage:"
	echo -e "-c\tcreate topology"
	echo -e "-s\tstart whole topology"
	echo -e "-d\tdestroy topology"
	echo -e "-p\tstop topology"
	echo -e "-h\tusage (this screen)"
}


function destroy() {
	echo -e "Destroy Topology" >&10

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
	echo -e "Start Topology" >&10
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
	echo -e "Stop Topology" >&10

	sudo lxc-stop -n "01t01"
	sudo lxc-stop -n "01r01"

	sudo lxc-stop -n "02t01"
	sudo lxc-stop -n "02r01"
}

function create() {
	clear
	cat $(dirname $(dirname "${BASH_SOURCE[0]}"))/assets/topology-create-message.txt >&10
	echo -e "wait 10 seconds, CTRL-C to interrupt installation" >&10
	sleep 1

	clear
	echo -e "Create Bridges" >&10
	create_bridges

	# delete outdated logfiles and create file as
	# current user id, sudo'ed environments will
	# not help us
	rm -rf $logfilepath
	touch $logfilepath

	echo -e "Create Topology" >&10
	echo -e "Create Terminals Instances" >&10
	$(dirname "${BASH_SOURCE[0]}")/../guests/terminals/01t01/cmd.sh -n "01t01" -l $logfilepath
	$(dirname "${BASH_SOURCE[0]}")/../guests/terminals/02t01/cmd.sh -n "02t01" -l $logfilepath

	echo -e "Create Routers Instances" >&10
	$(dirname "${BASH_SOURCE[0]}")/../guests/routers/01r01/cmd.sh -n "01r01" -l $logfilepath
	$(dirname "${BASH_SOURCE[0]}")/../guests/routers/02r01/cmd.sh -n "02r01" -l $logfilepath

	start
}

opt_verbose=false

opt_create=false
opt_start=false
opt_stop=false
opt_destroy=false

while getopts "csdhpv" opt; do
  case $opt in
    c)
			opt_create=true
    ;;
    s)
			opt_start=true
    ;;
    p)
			opt_stop=true
    ;;
    d)
			opt_destroy=true
    ;;
    v)
			opt_verbose=true
    ;;
    h)
			usage
			exit 0
		;;
    \?) echo "Invalid option -$OPTARG" >&1
    ;;
  esac
done

# fallthrough options
if [ "$opt_verbose" = true ] ; then
	echo ""
else
	enable_silent_mode_with_log
fi

# branch in modes
if [ "$opt_create" = true ] ; then
	create
	exit 0
fi
if [ "$opt_stop" = true ] ; then
	stop
	exit 0
fi
if [ "$opt_start" = true ] ; then
	start
	exit 0
fi
if [ "$opt_destroy" = true ] ; then
	destroy
	exit 0
fi

usage
exit 1
