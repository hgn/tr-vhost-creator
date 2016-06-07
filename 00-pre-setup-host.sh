#!/bin/bash

DIST="$(lsb_release -i | cut -f 2-)"

install_ubuntu ()
{
	apt-get install lxc
}

install_arch ()
{
	sudo pacman -Sy --noconfirm ebtables community/lxc community/debootstrap
	echo -e "Change your network setup and bridge everything"
	echo -e "sudo rm /etc/resolv.conf"
	echo -e "sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf"
	echo -e ""
	echo -e "cat <<-STR > /etc/systemd/network/lxcbr0.netdev"
	echo -e "[NetDev]"
	echo -e "Name=lxcbr0"
	echo -e "Kind=bridge"
	echo -e "STR"
	echo -e ""
	echo -e "cat <<-STR > /etc/systemd/network/enFoo.network"
	echo -e "[Match]"
	echo -e "Name=enFOO"
	echo -e ""
	echo -e "[Network]"
	echo -e "Bridge=lxcbr0"
	echo -e "STR"
	echo -e ""
	echo -e "cat <<-STR > /etc/systemd/network/br0.network"
	echo -e "[Match]"
	echo -e "Name=lxcbr0"
	echo -e ""
	echo -e "[Network]"
	echo -e "DHCP=ipv4"
	echo -e "STR"
	echo -e ""
	echo -e "sudo systemctl enable systemd-networkd.service"
	echo -e "sudo systemctl enable systemd-resolved.service"
	echo -e "sudo systemctl start systemd-networkd.service"
	echo -e "sudo systemctl start systemd-resolved.service"
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
