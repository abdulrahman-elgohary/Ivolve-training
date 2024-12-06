# Lab 13: Launching an EC2 Instance  

## Objective  
Create a VPC with public and private subnets, launch an EC2 instance in each subnet, and configure secure access to the private EC2 using a bastion host.

---

## Steps  


### 1. Create a VPC  

1. **Create a new VPC**:  

![image](https://github.com/user-attachments/assets/79ba769e-b968-4b42-abf5-b0eaf5c2c06f)
  
![image](https://github.com/user-attachments/assets/b1e8623a-282a-4dda-822a-dc5895926d32)

2. **Add an Internet Gateway for the VPC**:  

![image](https://github.com/user-attachments/assets/9d45d31b-0ca4-417b-8127-2bdd9a049add)


---

### 2. Create Subnets  

1. **Create a Public Subnet**:  

![image](https://github.com/user-attachments/assets/b92ea532-86c1-460b-8267-c608f3309efa)


3. **Create a Private Subnet**:  

![image](https://github.com/user-attachments/assets/d42eebbb-441c-46c8-92a1-da5d37e28537)


---

### 3. Configure Route Tables  

1. **Create a Route Table for the Public Subnet**:  

![image](https://github.com/user-attachments/assets/e9629d6e-882a-4492-95d7-308b5939d130)


2. **Attach the Public Subnet to the Route Table also add the Internet Gateway to the route table**:  

![image](https://github.com/user-attachments/assets/df7fd5e3-4c7f-4d3a-bb35-b37da4b709c2)

---

 
### 4. Launch EC2 Instances  

1. **Launch a Public EC2 Instance**:  

![image](https://github.com/user-attachments/assets/442e2919-a336-424b-9674-75a525fc47f9)


2. **Launch a Private EC2 Instance**:  

![image](https://github.com/user-attachments/assets/a85f54c7-09fa-46f9-856d-154036f6e801)

---

### 5. Configure Security Groups  

1. **Public EC2 Security Group**: Allow inbound SSH (port 22) and HTTP (port 80):  

![image](https://github.com/user-attachments/assets/2ce478b0-a95d-473f-9ce6-6b37c4c3c01a)


2. **Private EC2 Security Group**: Allow inbound SSH (port 22) only from the Public EC2 instance IP:  

![image](https://github.com/user-attachments/assets/15cc7a92-5ba8-4900-84c1-7a7747a7c102)


---

### 6. SSH to Private EC2 Using Bastion Host  

1. **SSH into the Public EC2 (Bastion Host)**:  
    ```bash
    ssh -i <key-pair-file> ubuntu@<public-ec2-ip>
    ```
    ![image](https://github.com/user-attachments/assets/f6a6a044-3a34-4269-a19c-c3f2b023a127)

2. **Upload the key-pair-file for Private Ec2 to Bastion Host First**:  

    ```bash
    scp -i <key-pair-file> ubuntu@<public-ec2-ip>:<Path to be move>
    ```
    
  - Change the permission for the key-pair-file.
    
    ```bash
    chmod 400 <key-pair-file>
    ```

3. **From the Bastion Host, SSH into the Private EC2**:  

   ```bash
    ssh -i <key-pair-file> ubuntu@<private-ec2-ip>
    ```
    ![image](https://github.com/user-attachments/assets/78bbc590-94e2-4183-ad2a-0b23a2220ae3)

---

## Notes  

- Ensure the key pair is available and configured correctly for both instances.  
- Test connectivity between the Bastion Host and the Private EC2 instance to verify security group configurations.  
- Replace placeholders such as `<vpc-id>`, `<ami-id>`, `<key-pair-file>`, etc., with actual values.


