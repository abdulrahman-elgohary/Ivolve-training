# Lab 15: SDK and CLI Interactions  

## Objective  
Use the AWS CLI to create an S3 bucket, configure permissions, upload/download files to/from the bucket, and enable versioning and logging.

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

- Configure the AWS CLI by inserting your `Access Key ID` , `Secret Access Key` , `Region` , `Output Format`
     
```bash
aws configure
```

---
## Steps  

### 1. Create an S3 Bucket  

1. **Run the following command to create an S3 bucket**:  
    ```bash
    aws s3api create-bucket --bucket <bucket-name> --region <region-name> --create-bucket-configuration LocationConstraint=<region-name>
    ```  
    Replace `<bucket-name>` and `<region-name>` with appropriate values (e.g., `my-bucket-12345` and `us-east-1`).
   
    ![image](https://github.com/user-attachments/assets/10b33c66-e497-43f5-b609-3e6b3f3f0eca)

    ![image](https://github.com/user-attachments/assets/e89b15a4-62d7-4733-a22c-55d37df40384)

---

### 2. Configure Permissions  

1. **Uncheck third option in Block public access**:  

    ```bash
    aws s3api put-public-access-block --bucket <bucket-name>  --public-access-block-configuration 
   "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=false,RestrictPublicBuckets=true"
    ```
    ![image](https://github.com/user-attachments/assets/78557571-70cc-4509-a409-e7e7dc387f76)

    ![image](https://github.com/user-attachments/assets/8cc9329d-2c06-45f5-a49e-bd69d1ab61a4)

2. **Set a public read policy**:  
    ```bash
    aws s3api put-bucket-policy --bucket <bucket-name> --policy '{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::<bucket-name>/*"
        }
      ]
    }'
    ```
    ![image](https://github.com/user-attachments/assets/7e2bb8e7-00ec-4841-859a-c4624fd9bfb5)

    ![image](https://github.com/user-attachments/assets/795b0a82-ae04-4cf3-b366-a5ade5eb6a49)

---

### 3. Upload Files  

**Upload a file to the S3 bucket**:  
    
  ```bash
  aws s3 cp <file-path> s3://<bucket-name>/
  ```  

  Replace `<file-path>` with the location of the file on your local system.
    

  ![image](https://github.com/user-attachments/assets/3aa027d3-f044-4b04-b9ea-d5984c6f6754)

---

### 4. Download Files  

**Download a file from the S3 bucket**:  

```bash
aws s3 cp s3://<bucket-name>/<file-name> <destination-path>
```  

Replace `<file-name>` with the name of the file in the bucket and `<destination-path>` with the desired location on your local system.

![image](https://github.com/user-attachments/assets/3186f3f1-e4e2-457c-ac02-f4f219e56248)

---

### 5. Enable Versioning  

1. **Enable versioning for the bucket**:  
    ```bash
    aws s3api put-bucket-versioning --bucket <bucket-name> --versioning-configuration Status=Enabled
    ```
    ![image](https://github.com/user-attachments/assets/01081534-0763-4351-a364-4d4c08cf33b6)

2. **Verify versioning status**:  
    ```bash
    aws s3api get-bucket-versioning --bucket <bucket-name>
    ```
    ![image](https://github.com/user-attachments/assets/21692485-5bc9-4ca0-ba7a-1ad3216b153a)

    ![image](https://github.com/user-attachments/assets/81fb7d5a-3d4e-44ab-af1b-c67c3afd8a15)

---

### 6. Enable Logging  

1. **Create a logging bucket**:  
    ```bash
    aws s3api create-bucket --bucket <logging-bucket-name> --region <region-name>
    ```
    ![image](https://github.com/user-attachments/assets/8d6c460f-8696-4837-b544-64e3983884c5)

2. **Enable logging for the original bucket**:  
    ```bash
    aws s3api put-bucket-logging --bucket <bucket-name> --bucket-logging-status '{
      "LoggingEnabled": {
        "TargetBucket": "<logging-bucket-name>",
        "TargetPrefix": "logs/"
      }
    }'
    ```
    ![image](https://github.com/user-attachments/assets/f372c2ad-a7da-484e-aeb9-3031e6acb05c)

---

## Verification  

1. **List objects in the bucket** to confirm uploads:  
    ```bash
    aws s3 ls s3://<bucket-name>/
    ```
    ![image](https://github.com/user-attachments/assets/dd22c9d0-fc82-44a9-a7cf-6dc6c8112881)

2. **Check versioning by uploading the same file again** and listing all versions:  
    ```bash
    aws s3api list-object-versions --bucket <bucket-name>
    ```
    ![image](https://github.com/user-attachments/assets/2d25cca9-0e67-4a2b-9dae-cb41791eca81)

3. **Verify logging by checking the logging bucket**:  
    ```bash
    aws s3 ls s3://<logging-bucket-name>/logs/
    ```

---

## Notes  

- Replace placeholders (`<bucket-name>`, `<region-name>`, etc.) with actual values.  
- Ensure you have sufficient IAM permissions for all commands.  
- Use unique bucket names as S3 bucket names are globally unique.

