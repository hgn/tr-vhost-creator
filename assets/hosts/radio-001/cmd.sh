#!/bin/bash

source ./$( dirname "${BASH_SOURCE[0]}" )/../../lib.sh

name=$(randomString 10)
distribution=ubuntu

while getopts ":n:p:" opt; do
  case $opt in
    n) name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo -e "Generate image"
echo -e "  Name:         $name"
echo -e "  Distribution: $distribution"

sudo LC_ALL=C lxc-create --bdev dir -f $(dirname "${BASH_SOURCE[0]}")/lxc-config -n $name -t $distribution --logpriority=DEBUG --logfile $(dirname "${BASH_SOURCE[0]}")/guests.log
sudo lxc-start -n $name -d
sleep 3s
echo -e "Copy files to guest"
cat $(dirname "${BASH_SOURCE[0]}")/post-install-phase-01.sh | sudo lxc-attach -n $name --clear-env -- bash -c 'cat >/tmp/post-install.sh'

# FIXME: check if host is Ubuntu. Required if host is using a proxy
cat /etc/apt/apt.conf | sudo lxc-attach -n  $name --clear-env -- bash -c 'cat >/etc/apt/apt.conf'

sudo lxc-attach -n $name --clear-env -- bash /tmp/post-install.sh
