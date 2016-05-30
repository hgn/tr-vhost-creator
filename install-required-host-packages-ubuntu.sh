#!/bin/bash

echo "$(lsb_release -is)"
DIST="$(lsb_release -i | cut -f 2-)"

install_ubuntu ()
{
	apt-get install lxc
}

install ()
{
	case $DIST in
				 "Ubuntu")
					 install_ubuntu
					 ;;
				 *)
					 ;;
	esac
}


install
lxc-checkconfig
