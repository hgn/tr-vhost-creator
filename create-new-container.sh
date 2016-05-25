#!/bin/sh

sudo lxc-create -n tr-ubuntu -t ubuntu
sleep 1s

echo "copy ip config"
sudo cp assets-lxc-host/config /var/lib/lxc/tr-ubuntu/config

sudo lxc-start -n tr-ubuntu -d
sleep 3s
sudo lxc-ls --fancy

# for debian based hosts we copy apt conf just to get
# proxy configurations
echo "copy files to guest"
cat post-install.sh   | sudo lxc-attach -n  tr-ubuntu -- sh -c 'cat >/tmp/post-install.sh'
cat /etc/apt/apt.conf | sudo lxc-attach -n  tr-ubuntu -- sh -c 'cat >/etc/apt/apt.conf'

sudo lxc-info -n tr-ubuntu


echo "Attach to guest via"
echo "sudo lxc-console -n tr-ubuntu"
echo "CTRL A CTRL A Q to quit"
echo "sh /tmp/post-install.sh"
echo "lxc-stop --name tr-ubuntu"
echo "lxc-destroy --name tr-ubuntu"
echo "sudo lxc-info -n tr-ubuntu"
