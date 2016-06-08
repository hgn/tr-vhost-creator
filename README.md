sudo lxc-info -n tr-ubuntu

sudo lxc-attach -n tr-ubuntu

Attach to guest via
sudo lxc-console -n tr-ubuntu
CTRL A CTRL A Q to quit


lxc-stop --name tr-ubuntu

lxc-destroy --name tr-ubuntu
