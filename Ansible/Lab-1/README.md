# Lab 7: Ansible Installation  

## Objective  
Install and configure Ansible Automation Platform on a control node (Ubuntu), create an inventory of managed hosts, and perform ad-hoc commands to check functionality.

---

## Steps  

### 1. Install Ansible on the Control Node  

1. **Update system packages**:  
    ```bash
    sudo apt update -y
    ```

2. **Install Ansible**:  
    ```bash
    sudo apt install ansible -y
    ```

---

### 2. Configure the Inventory File  

1. **Create an inventory file** (`hosts`):  
    ```bash
    sudo vim inventory
    ```

2. **Add managed hosts to the inventory**:  
    ```
    [$GROUP]
    $SERVER_1
    $SERVER_2

    [$GROUP:vars]
    ansible_user=$SERVER_USER
    ansible_ssh_private_key_file= $KEY_PATH
    ```
    ![image](https://github.com/user-attachments/assets/3964b82d-1007-4c3f-817d-4bc775480216)

    - Replace `server1` and `server2` with your actual hostnames or IPs.  
    - Replace `ansible_user=dumb` with your username.
    
3. **Add ansible configuration file**:  
  
    ```bash
    vim ansible.cfg
    ```
    - Add the following entry
    ``` 
    [defaults]
    inventory= ./inventory
    remote_user= $USER
    ask_pass= false
    

    [Privilege escalation]
    become=true
    become_method=sudo
    become_user=root
    become_ask_pass=false

    ```
    ![image](https://github.com/user-attachments/assets/4ec3fc9c-5e21-48b7-bf21-daa195b4b2ee)

    - Replace `remote_user` with your actual hostname user.  

---

### 3. Verify Ansible Installation  

1. **Check the Ansible version**:  
    ```bash
    ansible --version
    ```
    ![image](https://github.com/user-attachments/assets/f4a5cea1-caf9-479b-822f-29e72209a69b)

2. **Ping all managed hosts to verify connectivity**:  
    ```bash
    ansible all -m ping
    ```
    ![image](https://github.com/user-attachments/assets/e82733de-cfda-4ee2-9f40-614ee1071a78)

---

### 4. Perform Ad-hoc Commands  

1. **Check uptime of all managed hosts**:  
    ```bash
    ansible all -a "uptime"
    ```
    ![image](https://github.com/user-attachments/assets/13748a7e-fd48-474e-a76c-78e3b3df49a5)

2. **Install a package (e.g., `nginx`) on managed hosts**:  
    ```bash
    ansible all -b -m apt -a "name=nginx state=present"
    ```
---
# I created a script to automate the process, eliminating the need to run each command manually.


