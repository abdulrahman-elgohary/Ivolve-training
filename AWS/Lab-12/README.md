# Lab 12: AWS Security  

## Objective  
Set a billing alarm, and manage IAM users and groups. The task includes configuring access permissions and enabling MFA for specific users.
---
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

1. **List All IAM Users**:  
    ```bash
    aws iam list-users
    ```

2. **List All IAM Groups**:  
    ```bash
    aws iam list-groups
    ```

---

### 5. Test Developer User Access  

1. **Switch to dev-user** credentials for testing programmatic access.  

2. **Access EC2** (should work):  
    ```bash
    aws ec2 describe-instances --profile dev-user
    ```

3. **Try Accessing S3** (should fail due to lack of permissions):  
    ```bash
    aws s3 ls --profile dev-user
    ```

---

## Notes  
- Ensure **admin-1** and **admin-2-prog** have appropriate MFA and security settings.  
- Developers can only access EC2 but not S3 based on the policies attached.  
- Adjust IAM policies as needed to refine access control.
