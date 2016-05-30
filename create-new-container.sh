#!/bin/sh

sudo lxc-create -f assets-lxc-host/lxc-config -n tr-ubuntu -t ubuntu
sleep 1s

sudo lxc-start -n tr-ubuntu -d
sleep 3s
sudo lxc-ls --fancy

# for debian based hosts we copy apt conf just to get
# proxy configurations
echo "copy files to guest"
cat assets-lxc-host/post-install.sh   | sudo lxc-attach -n  tr-ubuntu -- sh -c 'cat >/tmp/post-install.sh'
cat /etc/apt/apt.conf | sudo lxc-attach -n  tr-ubuntu -- sh -c 'cat >/etc/apt/apt.conf'

sudo lxc-info -n tr-ubuntu

echo -e "\n\n"

sudo lxc-attach -n tr-ubuntu -- sh /tmp/post-install.sh

echo "Attach to guest via"
echo "sudo lxc-console -n tr-ubuntu"
echo "CTRL A CTRL A Q to quit"
echo "sh /tmp/post-install.sh"
echo "lxc-stop --name tr-ubuntu"
echo "lxc-destroy --name tr-ubuntu"
echo "sudo lxc-info -n tr-ubuntu"
