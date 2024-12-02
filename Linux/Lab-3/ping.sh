#!/bin/bash
INTERFACE="ens33"
SUBNET=$(ip -o -4 addr show $INTERFACE | awk '{print $4}' | cut -d'/' -f1 | cut -d'.' -f1-3)
for i in {0..255}; do 


 IP=$SUBNET.$i
 ping -c 1 -W 1 $IP

    if [ $? -eq 0 ]; then
      echo "Server $IP is up and running"
    else
      echo "Server $IP is unreachable"
    fi
done

