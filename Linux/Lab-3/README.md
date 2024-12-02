# Lab 3: Shell Scripting Basics 2  

## Objective  
Create a shell script to ping every server in the `172.16.17.x` subnet (where `x` ranges from 0 to 255). The script should display a message indicating whether each server is up or unreachable.  

## Steps  

## 1. Create the Shell Script  
Create a shell script named `ping.sh` with the following contents:  

```bash
#!/bin/bash
INTERFACE="ens33"
SUBNET=$(ip -o -4 addr show $INTERFACE | awk '{print $4}' | awk 'NR==2' | cut -d'/' -f1 | cut -d'.' -f1-3)
for i in {0..255}; do

 IP=$SUBNET.$i
 ping -c 1 -W 1 $IP

    if [ $? -eq 0 ]; then
      echo "Server $IP is up and running"
    else
      echo "Server $IP is unreachable"
    fi
done
```
