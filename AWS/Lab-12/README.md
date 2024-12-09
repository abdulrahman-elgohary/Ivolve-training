# Lab 12: AWS Security  

## Objective  
Set a billing alarm, and manage IAM users and groups. The task includes configuring access permissions and enabling MFA for specific users.
---

## Prequestites 

**Download Aws CLI Package.**
   
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

## Steps  

### 1. Set Billing Alarm

- **Go to `Billing and Cost Management` >> `Budgets`**. 

![image](https://github.com/user-attachments/assets/23662510-6268-4619-964a-f9655e3090f7)


- **Insert your thresshold budget and the e-mail that will receive the alert when you exceed this budget**.
  
![image](https://github.com/user-attachments/assets/612e57ff-7b35-4fe6-8529-53b612e347f8)


- **Choose Create a Budget**.

![image](https://github.com/user-attachments/assets/9623af67-cc5b-4368-b325-80f66e0e0cfb)

### 2. Create IAM Groups  

- Go to `IAM` Service >> `User groups` >> `Create Group`.
  
1. **Create Admin and Developer Groups**:  

![image](https://github.com/user-attachments/assets/b532f784-7ebb-410b-84c6-358d1551a952)

2. **Attach Policies to Groups**:
   
- Choose the Group from the list and go to `Permission` then `Add Permissions`.
  
- Attach the **AdministratorAccess** policy to the `admin` group:
  
![image](https://github.com/user-attachments/assets/a0c8940c-c640-4364-bcf4-32497dc1a7f2)

- Attach the **AmazonEC2ReadOnlyAccess** policy to the `developer` group:
  
![image](https://github.com/user-attachments/assets/f14d590e-a16e-4bdc-be9e-7e6ef7a459b2)



---

### 3. Create IAM Users  

1. **Create an Admin User with Console Access Only**:  

![image](https://github.com/user-attachments/assets/43db390e-9363-493a-8afc-464faf8c2dc4)

2. **Enable MFA for Admin-1**:
   
- Go to **IAM Management Console** > **Users** > **admin-1** > **Security Credentials** > **Manage MFA**.
      
![image](https://github.com/user-attachments/assets/6bc0c59d-51ee-4324-bc33-a0033bf5aeb3)


3. **Create a Programmatic Admin User** (CLI Access Only):  
Go to **IAM Management Console** > **Users** > **admin-2** > **Security Credentials** > **Access Keys**.

![image](https://github.com/user-attachments/assets/14b54356-79ac-4242-b0b3-1272d3357923)

- Don't forget to to download the csv file that holding your credentials.

![image](https://github.com/user-attachments/assets/ed934d41-a5cb-422e-9e02-00ec32e2c9fe)

4. **Create a Developer User with Both Console and CLI Access**:  
- Go to **IAM Management Console** > **Users** > **Create user**.

- Choose **Provide user to the AWS Management Console**
  
![image](https://github.com/user-attachments/assets/7512b055-13b6-44b4-9bb4-ce330c094019)

- Also Create an Access Key same as the previous steps.

![image](https://github.com/user-attachments/assets/d11c63a1-ac1c-4e26-b1f9-91b9f983f283)

---

### 4. Verify User and Group Setup  

1- **admin-1-user MFA**

![image](https://github.com/user-attachments/assets/cdbcdb66-3bbb-4cc6-b122-a6b8b95daf4b)  ![image](https://github.com/user-attachments/assets/096cfe2f-5df0-4000-b54e-a814b37782a0)



2. **List All IAM Users**:  

- Configure the AWS CLI
     
```bash
aws configure
```
- Insert you `Access Key ID` , `Secret Access Key` , `Region` , `Output Format`

![image](https://github.com/user-attachments/assets/dfc597de-c504-4025-b953-a454c8e36825)


 ```bash
 aws iam list-users
 ```

![image](https://github.com/user-attachments/assets/9dfc42ac-7359-4450-8b8c-6f30a877c381)


3. **List All IAM Groups**:
   
 ```bash
 aws iam list-groups
 ```
![image](https://github.com/user-attachments/assets/be3d7dcc-9ad4-4dbf-ae29-f10e24544192)

---

### 5. Test Developer User Access  

1. **Switch to dev-user** credentials for testing programmatic access.  

2. **Access EC2** (should fail due to lack of permissions):  
    ```bash
    aws ec2 describe-instances --profile dev-user
    ```
![image](https://github.com/user-attachments/assets/db85919a-6962-42a0-beab-ec41bc1d0a1d)

3. **Try Accessing S3** (should fail due to lack of permissions):  
    ```bash
    aws s3 ls --profile dev-user
    ```
![image](https://github.com/user-attachments/assets/f5e9fe98-cb85-4b8a-9e49-63b56e354b80)

---

