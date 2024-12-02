# Lab 1: User and Group Management  

## Objective  
- Create a new group named `ivolve` and a new user assigned to this group with a secure password. Configure the user’s permissions to allow installing Nginx with elevated privileges using the `sudo` tool (without requiring a password).  

## Steps  

## 1. Create a New Group  
Replace `ivolve` with the desired groupname.
```bash
sudo groupadd ivolve
```
![image](https://github.com/user-attachments/assets/7e341ddf-0ca4-402c-8a95-1bf020745069)
![image](https://github.com/user-attachments/assets/4bd33c0d-d9e3-441e-8ebb-ed5488f6a829)

## 2. Create a New User and Assign to the Group  
Replace `username` with the desired username.
```bash
sudo useradd -m -G ivolve -s /bin/bash <username>
```
![image](https://github.com/user-attachments/assets/ac85127f-71e9-4495-b01f-c5113f9cdd3d)
![image](https://github.com/user-attachments/assets/b6cd3337-d8a1-4766-8559-030c91870891)

## 3. Set a Secure Password for the User
```bash
sudo passwd <username>
```
![image](https://github.com/user-attachments/assets/c78d8f82-6cda-4059-8714-3acc72a8c7bc)
- Check the User details.
```bash
id <username>
```
![image](https://github.com/user-attachments/assets/148a489f-d007-4ad7-95e1-c47140903bf6)

## 4. Grant Sudo Privileges Without Password Prompt
```bash
sudo visudo
```
or 
```bash
sudo vim /etc/sudoers
```
- Add the following line to give permission to the user to install only nginx
```
<username> ALL=(ALL) NOPASSWD: /usr/bin/apt install nginx
```
![image](https://github.com/user-attachments/assets/6a1e9f53-33b5-45ea-a4d0-1f0dbc0b9100)

## 5. Install Nginx with Sudo (No Password Prompt)
- Switch to the created user and start installing nginx
```bash
su - <username> 
```
```bash
sudo apt install nginx
```
![image](https://github.com/user-attachments/assets/989a9850-2fc2-4a84-8fb6-0d7c2a206a58)

- Try to install httpd
  It will not be allowed because the user has only the permission to install nginx
![image](https://github.com/user-attachments/assets/302a037b-1abd-4a69-856e-ee712f0adec7)
##
# I created a script to automate the process, eliminating the need to run each command manually.
