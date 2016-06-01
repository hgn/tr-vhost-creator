#!/bin/bash

DIST="$(lsb_release -i | cut -f 2-)"

install_ubuntu ()
{
	apt-get install lxc
}

install_arch ()
{
	pacman -S community/lxc
	pacman -S community/debootstrap
}

install ()
{
	case $DIST in
				 "Ubuntu")
					 install_ubuntu
					 ;;
				 "Arch")
					 install_arch
					 ;;
				 *)
					 ;;
	esac
}

check_env ()
{
	if hash lsb_release 2>/dev/null; then
		return
	else
		echo -e "lsb_release not installed, please install the program first"
		echo -e "and call script again"
		echo -e "On arch linux please call"
		echo -e "\tsudo pacman -S community/lsb-release"
		exit
	fi
}


check_env
install
lxc-checkconfig
