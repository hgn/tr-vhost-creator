#!/bin/bash

source $(dirname "${BASH_SOURCE[0]}")/../../../assets/lib.sh

name=$(randomString 10)
logpath="guest.log"
distribution=ubuntu
dir=$(dirname "${BASH_SOURCE[0]}")

while getopts "n:l:" opt; do
  case $opt in
    n) name="$OPTARG"
    ;;
    l) logpath="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo -e "Generate image"
echo -e "  Name:         $name"
echo -e "  Distribution: $distribution"

sudo LC_ALL=C lxc-create --bdev dir -f $(dirname "${BASH_SOURCE[0]}")/lxc-config -n $name -t $distribution --logpriority=DEBUG --logfile $logpath -- -r xenial

sudo lxc-start -n $name -d
sleep 3s

# set ip configuration and restart container for now
cat $(dirname "${BASH_SOURCE[0]}")/etc.network.interfaces | sudo lxc-attach -n $name --clear-env -- bash -c 'cat >/etc/network/interfaces'
cat $(dirname "${BASH_SOURCE[0]}")/../shared/etc.sysctl.d.60-terminal.conf | sudo lxc-attach -n  $name --clear-env -- bash -c 'cat >/etc/sysctl.d/60-terminal.conf'
echo -e "Restarting guest to reload fresh network configuration"
sudo lxc-stop -n $name
sudo lxc-start -n $name -d
sleep 3s

# create admin account
cat $(dirname "${BASH_SOURCE[0]}")/../shared/post-install-phase-01.sh | sudo lxc-attach -n $name --clear-env -- bash -c 'cat >/tmp/post-install-phase-01.sh'
sudo lxc-attach -n $name --clear-env -- bash /tmp/post-install-phase-01.sh

# deep copy shared configuration files
cat $(dirname "${BASH_SOURCE[0]}")/../shared/copy-files-root/etc/smcroute.conf | sudo lxc-attach -n $name --clear-env -- bash -c 'cat >/etc/smcroute.conf'

# copy config files
cat $(dirname "${BASH_SOURCE[0]}")/../shared/vimrc | sudo lxc-attach -n $name --clear-env -- bash -c 'cat >/home/admin/.vimrc'
cat $HOME/.bashrc | sudo lxc-attach -n $name --clear-env -- bash -c 'cat >/home/admin/.bashrc'

# install required ubuntu software but first copy apt.conf
# required if host is using a proxy and proxy is required to use
# proxy too
if [ -f "/etc/apt/apt.conf" ]
then
	cat /etc/apt/apt.conf | sudo lxc-attach -n  $name --clear-env -- bash -c 'cat >/etc/apt/apt.conf'
fi
cat $(dirname "${BASH_SOURCE[0]}")/../shared/post-install-phase-02.sh | sudo lxc-attach -n $name --clear-env -- bash -c 'cat >/tmp/post-install-phase-02.sh'
ls -al $logpath
$(sudo lxc-attach -n $name --clear-env -- bash /tmp/post-install-phase-02.sh) > $logpath 2>&1

# install local packages
cat $(dirname "${BASH_SOURCE[0]}")/../shared/post-install-phase-03.sh | sudo lxc-attach -n $name --clear-env -- bash -c 'cat >/tmp/post-install-phase-03.sh'
$(sudo lxc-attach -n $name --clear-env -- bash /tmp/post-install-phase-03.sh) > $logpath 2>&1

sudo lxc-stop -n $name
