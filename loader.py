#!/usr/bin/env python3


import json
import pprint
import sys

INET_IFACE_NAME = "inet0"
INET_BRIDGE_NAME = "lxcbr0"

def load_configuration(filename):
    with open(filename) as json_data:
        d = json.load(json_data)
        json_data.close()
        return d

def bridge_handle(mode, bridge_name, db):
    print(bridge_name)

def terminal_gen_config(terminal_data):
    d = {}
    # standard data always present
    e  = "auto lo\n"
    e += "iface lo inet loopback\n\n"
    e += "auto inet0\n"
    e += "iface inet0 inet dhcp\n\n"

    # interface specific
    for interface_name, interface_data in terminal_data["interfaces"].items():
        e += "auto {}\n".format(interface_name)
        e += "iface {} inet static\n".format(interface_name)
        e += "  address {}\n".format(interface_data["ipv4-addr"])
        e += "  netmask {}\n".format(interface_data["ipv4-addr-netmask"])
        if "post-up" in interface_data:
            assert isinstance(interface_data["post-up"], list)
            for line in interface_data["post-up"]:
                e += "  post-up {}\n".format(line)
        e += "\n"
    d["debian-interface-conf"] = e

    e  = "lxc.network.type = veth\n"
    e += "lxc.network.name = {}\n".format(INET_IFACE_NAME)
    e += "lxc.network.flags = up\n"
    e += "lxc.network.link = {}\n".format(INET_BRIDGE_NAME)
    e += "lxc.network.hwaddr = 00:11:xx:xx:xx:xx\n\n"

    
    for interface_name, interface_data in terminal_data["interfaces"].items():
        e += "lxc.network.type = veth\n"
        e += "lxc.network.name = {}\n".format(interface_name)
        e += "lxc.network.flags = up\n"
        e += "lxc.network.link = {}\n".format(interface_data["lxr-link"])
        e += "lxc.network.hwaddr = {}\n\n".format(interface_data["lxr-hw-addr"])

    d["lxr-conf"] = e
    return d

def terminal_handle(mode, terminal_name, db):
    if terminal_name not in db["devices"]["terminals"]:
        print("terminal {} not defined".format(terminal_name)) 
        sys.exit(1)
    terminal = db["devices"]["terminals"][terminal_name]
    if mode == "gen-config":
        d = terminal_gen_config(terminal)
        print(d["debian-interface-conf"])
        print(d["lxr-conf"])


def load_topo(mode, db, topo):
    print("Description \"{}\"".format(topo["description"]))
    for k, v in topo["topo"].items():
        if k == "bridges":
            for bridge in v:
                bridge_handle(mode, bridge, db)
        if k == "terminals":
            for terminal in v:
                terminal_handle(mode, terminal, db)

def gen_configuration_file(mode, target_topo_name):
    d = load_configuration("conf.json")
    for topology in d["topologies"]:
        if target_topo_name == topology:
            load_topo(mode, d, d["topologies"][topology])
            return
    print("Configuration not found")
    sys.exit(1)


# create
# start
# stop
# destroy
# show    - 
# list
# get-config

mode = "gen-config"
gen_configuration_file(mode, "simple-three")
