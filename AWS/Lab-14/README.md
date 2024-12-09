
# Lab 14: Create AWS Load Balancer  

## Objective  
Create a VPC with two public subnets, launch two EC2 instances with Nginx and Apache installed using user data, and configure a Load Balancer to distribute traffic between the web servers.

---

## Steps  

### 1. Create a VPC  

1. **Create a new VPC**:  


 ![image](https://github.com/user-attachments/assets/8567219b-afe9-434c-90fc-7b976807a81d)


---

### 2. Create Public Subnets  

![image](https://github.com/user-attachments/assets/b72f1c2e-4137-4a2d-ba9f-ea8758657d8c)


---

### 3. Configure an Internet Gateway  

1. **Create an Internet Gateway Attach the Internet Gateway to the VPC**:  

![image](https://github.com/user-attachments/assets/e4f02fd3-20bf-46b9-81d2-5b00d685958b)

2. **Create a route table** for the public subnets:  

![image](https://github.com/user-attachments/assets/63fe877c-bb45-43c1-bff2-5dd45949ca0a)


3. **Add a route to allow internet access**:  

![image](https://github.com/user-attachments/assets/a310861d-9b6a-4a9e-afb9-85f6fb7e6643)

---

### 4. Launch EC2 Instances  

1. **Launch the first EC2 instance with Nginx installed using user data**:

  ```bash
  #!/bin/bash
  sudo apt update
  sudo apt install -y nginx
  echo "Welcome to Nginx!" > /var/www/html/index.html
  sudo systemctl restart nginx
  ```
  ![image](https://github.com/user-attachments/assets/c1dea19f-7cd8-4b81-9a19-0bc77686541d)

3. **Launch the second EC2 instance with Apache installed using user data**:  
  ```bash
  #!/bin/bash
  sudo apt update
  sudo apt install -y apache2
  echo "Welcome to Apache!" > /var/www/html/index.html
  sudo systemctl restart apache2
  ```
  ![image](https://github.com/user-attachments/assets/83375273-45d7-40c0-b124-85ccf842d1e5)

---

### 5. Create a Security Group for Load Balancer  

**Create a Security Group to allow HTTP and HTTPS traffic**:  

  ![image](https://github.com/user-attachments/assets/5ed372b1-2bc1-45ba-b05f-46ac9a2c17ac)

  
  ![image](https://github.com/user-attachments/assets/fcff3f2e-b3e1-4d57-b227-bcf2ca6dffb3)

---

### 6. Configure the Load Balancer  

1. **Create a Load Balancer**:  

   ![image](https://github.com/user-attachments/assets/a2b628a3-0881-4231-9624-24a842e2b892)


2. **Create a Target Group and register the two instances to it**:  

   ![image](https://github.com/user-attachments/assets/2459e11b-d86e-4fcc-87bd-581ac7f37a73)


3. **Create a Listener for the Load Balancer**:  

   ![image](https://github.com/user-attachments/assets/b70f34bf-0cd8-4eec-a836-65437f64c730)

---

## Verification  

1. **Access the Load Balancer's DNS name** (available in the AWS Management Console or via CLI):  

   ![image](https://github.com/user-attachments/assets/adb4c9bb-1d76-4663-b32e-7f32ffb83a52)


2 . **Ensure traffic is distributed between the Nginx and Apache servers**.  

![image](https://github.com/user-attachments/assets/2a13f2a3-eaea-4be9-8b57-83c6b40baa6e)

![image](https://github.com/user-attachments/assets/fa3f50db-425e-4af2-9921-26c870d20382)

---

