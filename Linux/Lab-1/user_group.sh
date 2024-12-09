#!/bin/bash
source ./variables.sh

sudo groupadd $GROUP
sudo useradd -m $USER -s /bin/bash -G $GROUP
echo "$USER:$PASS" | sudo chpasswd


sudo sed -i '/^root/a\\'"$USER"' ALL=(ALL) NOPASSWD: /usr/bin/apt install nginx' /etc/sudoers

