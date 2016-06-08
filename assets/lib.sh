#!/bin/bash

function randomString {
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

