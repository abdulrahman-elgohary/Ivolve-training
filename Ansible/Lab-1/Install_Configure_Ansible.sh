#!/bin/bash
#Change the values of the variables

GROUP="aws"
SERVER_1="44.222.61.128"
SERVER_2="18.232.186.66"

REMOTE_USER="mav"
USER="ubuntu"
KEY="~/ivolve/Ansible/Project1_Key.pem"

sudo apt update -y 

sudo apt install ansible -y

ansible --version 

if [ $? -eq 0 ]; then
	echo "Ansible Installation Completed Successfully"
else
	echo "Ansible Installation Failed"
fi

cat<<EOF > ansible.cfg
[defaults]

inventory= ./inventory
remote_user= $REMOTE_USER
ask_pass= false


[Privilege escalation]
become=true
become_method=sudo
become_user=root
become_ask_pass=false


EOF


cat<<EOF > inventory
[$GROUP]

$SERVER_1
$SERVER_2

[aws:vars]

ansible_user=$USER
ansible_ssh_private_key_file= $KEY


EOF

ansible all -m ping
if [ $? -eq 0 ]; then
echo "Ansible has been installed and configured Successfully"
else 
echo "Somewthing went wrong in the configuration"
fi
