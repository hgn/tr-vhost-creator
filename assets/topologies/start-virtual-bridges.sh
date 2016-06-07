#!/bin/bash

BRCTL_BIN="/sbin/brctl"
IP_BIN="/sbin/ip"

# function: add bridge
# 
function  addBr() {
local brName=$1
local brDev=$2 || ""
if [ -d /sys/class/net/${brName} ]; then
  # bridge exists
  return
else
 ${BRCTL_BIN} addbr ${brName}
 ${BRCTL_BIN} setfd ${brName} 0
 ${BRCTL_BIN} sethello ${brName} 5
 ${IP_BIN} link set dev ${brName} up
 if [ "${brDev}x" != "x" ]; then
     ${BRCTL_BIN} addif ${brName} ${brDev}
     ${IP_BIN} link set dev ${brDev} up
 fi
fi
}


addBr lxcbr5 eth5
