Go to billing and cost management >> Budgets 
![image](https://github.com/user-attachments/assets/23662510-6268-4619-964a-f9655e3090f7)

Insert you thresshold budget and the e-mail that will recieve the alert when you exceed this budget 
![image](https://github.com/user-attachments/assets/612e57ff-7b35-4fe6-8529-53b612e347f8)
Here is the budget
![image](https://github.com/user-attachments/assets/9623af67-cc5b-4368-b325-80f66e0e0cfb)

MFA
![image](https://github.com/user-attachments/assets/6bc0c59d-51ee-4324-bc33-a0033bf5aeb3)


### 2. Create IAM Groups  

1. **Create Admin and Developer Groups**:  
    ```bash
    aws iam create-group --group-name admin
    aws iam create-group --group-name developer
    ```

2. **Attach Policies to Groups**:  
    - Attach the **AdministratorAccess** policy to the `admin` group:  
      ```bash
      aws iam attach-group-policy --group-name admin --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
      ```

    - Attach the **AmazonEC2ReadOnlyAccess** policy to the `developer` group:  
      ```bash
      aws iam attach-group-policy --group-name developer --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
      ```

---

### 3. Create IAM Users  

1. **Create an Admin User with Console Access Only**:  
    ```bash
    aws iam create-user --user-name admin-1
    aws iam add-user-to-group --user-name admin-1 --group-name admin
    aws iam create-login-profile --user-name admin-1 --password <secure_password>
    ```

2. **Enable MFA for Admin-1**:  
    - Go to **IAM Management Console** > **Users** > **admin-1** > **Security Credentials** > **Manage MFA**.

3. **Create a Programmatic Admin User** (CLI Access Only):  
    ```bash
    aws iam create-user --user-name admin-2-prog
    aws iam add-user-to-group --user-name admin-2-prog --group-name admin
    aws iam create-access-key --user-name admin-2-prog
    ```

4. **Create a Developer User with Both Console and CLI Access**:  
    ```bash
    aws iam create-user --user-name dev-user
    aws iam add-user-to-group --user-name dev-user --group-name developer
    aws iam create-login-profile --user-name dev-user --password <secure_password>
    aws iam create-access-key --user-name dev-user
    ```

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
