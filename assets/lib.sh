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

function lxc-exec()
{
	HOST=$1
	USER=$2
	CMD=$3
	sudo lxc-attach -n $HOST --clear-env -- bash -c "su - $USER -c \"$CMD\""
}

function lxc-exec-root()
{
	HOST=$1
	CMD=$2
	sudo lxc-attach -n  $name --clear-env -- bash $CMD
}


function detect-os ()
{
  if [[ ( -z "${os}" ) && ( -z "${dist}" ) ]]; then
    if [ -e /etc/lsb-release ]; then
      . /etc/lsb-release

      if [ "${ID}" = "raspbian" ]; then
        os=${ID}
        dist=`cut --delimiter='.' -f1 /etc/debian_version`
      else
        os=${DISTRIB_ID}
        dist=${DISTRIB_CODENAME}

        if [ -z "$dist" ]; then
          dist=${DISTRIB_RELEASE}
        fi
      fi

    elif [ `which lsb_release 2>/dev/null` ]; then
      dist=`lsb_release -c | cut -f2`
      os=`lsb_release -i | cut -f2 | awk '{ print tolower($1) }'`

    elif [ -e /etc/debian_version ]; then
      os=`cat /etc/issue | head -1 | awk '{ print tolower($1) }'`
      if grep -q '/' /etc/debian_version; then
        dist=`cut --delimiter='/' -f1 /etc/debian_version`
      else
        dist=`cut --delimiter='.' -f1 /etc/debian_version`
      fi

    else
      unknown_os
    fi
  fi

  if [ -z "$dist" ]; then
    unknown_os
  fi

  # remove whitespace from OS and dist name
  os="${os// /}"
  dist="${dist// /}"

  echo "Detected operating system as $os/$dist."
}
