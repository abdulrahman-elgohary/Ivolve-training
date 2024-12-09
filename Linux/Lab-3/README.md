# Lab 3: Shell Scripting Basics 2  

## Objective  
Create a shell script to ping every server in the `192.168.199.x` subnet (where `x` ranges from 0 to 255). The script should display a message indicating whether each server is up or unreachable.  

## Steps  

## 1. Create the Shell Script  
- Create a shell script named `ping.sh` with the following contents:  

```bash
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
```
## 2. Run the Script
```bash
source ./ping.sh
```
- Notice here the only server that responds
  
![image](https://github.com/user-attachments/assets/85e92ba1-6c1d-40fa-8089-6ef252528db9)

- Check the IP of the Server you find it matches the one who responded 
```bash
ifconfig
```
![image](https://github.com/user-attachments/assets/b616a267-64f9-4856-8f5c-b997a9840586)



