#!/bin/sh

sudo lxc-create -n tr-ubuntu -t ubuntu
sudo lxc-start -n tr-ubuntu -d
sleep 5s

# for debian based hosts we copy apt conf just to get
# proxy configurations
echo "copy files to guest"
cat post-install.sh   | sudo lxc-attach -n  tr-ubuntu -- sh -c 'cat >/tmp/post-install.sh'
cat /etc/apt/apt.conf | sudo lxc-attach -n  tr-ubuntu -- sh -c 'cat >/etc/apt/apt.conf'


echo "Attach to guest via"
echo "sudo lxc-console -n tr-ubuntu"
echo "CTRL A CTRL A Q to quit"
echo "sh /tmp/post-install.sh"
echo "lxc-stop --name tr-ubuntu"
echo "lxc-destroy --name tr-ubuntu"
