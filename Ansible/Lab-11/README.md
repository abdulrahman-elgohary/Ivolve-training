# Lab 11: Ansible Dynamic Inventories  

## Objective  
Set up Ansible dynamic inventories to automatically discover and manage infrastructure. Use an Ansible Galaxy role to install Apache.

---

## Steps  

### 1. Install required dependencies 
  
1. **Install python3-pip and boto3 Packages.**
   
   ```bash
    sudo apt-get install python3-pip -y
    pip3 install boto3 botocore -y
    ```
   
2. **Install Curl command.**

    ```bash
    sudo apt install curl -y
    ```
      
3. **Download Aws CLI Package.**
   
    ```bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    ```
    - Unzip the Installation File
      
    ```bash
    unzip awscliv2.zip
    ```
    - Run the Installation Script
      
    ```bash
    sudo ./aws/install
    ```
   - Configure the AWS CLI
     
   ```bash
   aws configure
   ```
   - Insert you `Access Key ID` , `Secret Access Key` , `Region` , `Output Format`

    ![image](https://github.com/user-attachments/assets/1f7ca467-3783-4f3f-b3f6-bea0243dec6b)

    
5. **Download a dynamic inventory script** (for AWS in this example):  
    ```bash
    curl -O https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/aws_ec2.py
    chmod +x aws_ec2.py
    ```

6. **Create an inventory configuration file (`aws_ec2.yml`)**:  
    ```yaml
    plugin: aws_ec2
    regions:
      - us-east-1
    keyed_groups:
      - key: tags
        prefix: tag
    ```

---

### 2. Use an Ansible Galaxy Role to Install Apache  

1. **Install the Apache role from Ansible Galaxy**:  
    ```bash
    ansible-galaxy install geerlingguy.apache
    ```

2. **Create a playbook (`install_apache.yml`)**:  
    ```yaml
    ---
    - name: Install Apache using Dynamic Inventory
      hosts: tag_Name_WebServers
      become: true
      roles:
        - geerlingguy.apache
    ```

---

### 3. Run the Playbook  

To execute the playbook with the dynamic inventory:  
```bash
ansible-playbook -i aws_ec2.yml install_apache.yml
