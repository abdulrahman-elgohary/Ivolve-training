# Lab 6: SSH Key Generation and Configuration  

## Objective  
Generate public and private SSH keys and enable key-based SSH access from your machine to another VM. Configure SSH so that you can run the command `ssh ivolve` without specifying the username, IP address, or key.

---

## Steps  

## 1. Generate SSH Keys  

- Run the following command to generate a public-private key pair:  
```bash
ssh-keygen -t rsa -b 4096 
```
![image](https://github.com/user-attachments/assets/b8e19ccb-d044-48dd-82e3-8d7cad65a316)

## 2. Copy the Public Key to the Remote VM
```bash
ssh-copy-id user@remote_vm_ip
```
![image](https://github.com/user-attachments/assets/7728e5c3-4812-4281-abce-d27f23dbfd15)

- Try to ssh to the remote server
  
![image](https://github.com/user-attachments/assets/683b9f94-0b05-4a26-98a3-ceb05f986134)

## 3. Configure SSH for Key-Based Access

- On the remote server change the configuration of ssh service
```bash
sudo vim /etc/ssh/sshd_config
```

- Delete the hash sign from the following lines
```bash
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
```
- Restart the ssh server on remote server
```bash
sudo systemctl restart sshd
```
![image](https://github.com/user-attachments/assets/735eba81-9e27-4b3c-963b-279764424303)

## 4. Create an SSH Config File for Simplified Access

- On the main server add a configuration file to simplify access to the remote server
```bash
sudo vim ~/.ssh/config
```
- Add the following entry
```
Host ivolve
    HostName <remote_vm_ip>
    User <user>
    IdentityFile ~/.ssh/id_rsa
```

![image](https://github.com/user-attachments/assets/3d16a551-17b5-4bf0-bf0d-2d19bfd61655)

- Test the connection
  
![image](https://github.com/user-attachments/assets/521e4349-0996-484c-9174-b815fd2e9775)

