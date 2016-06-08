#!/bin/bash

function  addBr() {
	local brName=$1
	local brDev=$2 || ""
	if [ -d /sys/class/net/${brName} ]; then
		# bridge exists
		return
	else
		sudo ${BRCTL_BIN} addbr ${brName}
		sudo ${BRCTL_BIN} setfd ${brName} 0
		sudo ${BRCTL_BIN} sethello ${brName} 5
		sudo ${IP_BIN} link set dev ${brName} up
		if [ "${brDev}x" != "x" ]; then
			sudo ${BRCTL_BIN} addif ${brName} ${brDev}
			sudo ${IP_BIN} link set dev ${brDev} up
		fi
	fi
}


function randomString() {
	if [[ -n $1 ]] && [[ "$1" -lt 20 ]]; then
		local myStrLength=$1;
	else
		local myStrLength=8;
	fi

	local mySeedNumber=$$`date +%N`;
	local myRandomString=$( echo $mySeedNumber | md5sum | md5sum );
	echo "${myRandomString:2:myStrLength}"
}

function questionYN {
	prompt=shift
	read -p $prompt -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
    		echo "y"
    		return
	fi
	echo n
}

