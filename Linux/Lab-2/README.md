# Lab 2: Shell Scripting Basics 1  

## Objective  
Schedule a script to run daily at 5:00 PM that automates checking disk space usage for the root file system and sends an email alert if usage exceeds a specified threshold (10%).  

## Steps  

## 1. Install `msmtp` and `mailutils` packages
- These packages will allow you to send the e-mail alert to your Gmail
```bash
sudo apt update -y
```
![image](https://github.com/user-attachments/assets/be4bf329-07cd-428b-8119-e924b3eab3c1)

```bash
sudo apt install msmtp mailutils -y
```
![image](https://github.com/user-attachments/assets/472f62c6-a826-4a6c-b54f-5ac3ecca529c)

## 2. Generate a TOKEN for you Gmail 
- The token will be used to authenticate your server to the Gmail account.
- Go to the following link: https://support.google.com/accounts/answer/185833?hl=en

- Choose Create and manage your app passwords under `Create & use app passwords` section.

![image](https://github.com/user-attachments/assets/55ecbf60-0d2d-45f5-a65c-800ae26ccd60)

- Create a new app password

![image](https://github.com/user-attachments/assets/73c7cf9e-157a-4613-8f6a-2b088f7986df)

- Save the password to use it later for authentication
  
![image](https://github.com/user-attachments/assets/77a0ce4f-2dde-4db6-b51b-7fa3efd0f0a6)

## 3. Change the configuration file of msmtp service

```bash
vim ~/.msmtprc
```
- Add the following lines and change the E-mail and Password 
```
# Gmail SMTP settings
account gmail
host smtp.gmail.com
port 587
from $EMAIL
auth on
user $EMAIL
password $PASS
tls on
tls_starttls on
logfile ~/.msmtp.log

# Set default account to gmail
account default : gmail
```
- Change the permission of the configuration file
```bash
chmod 600 ~/.msmtprc
```
![image](https://github.com/user-attachments/assets/b8a76c9c-c98e-4ed2-b38e-2b443eb00178)

## 4. Create a Script to Check the Disk Space Usage
```bash
vim disk_space_alert.sh
```
- Add the following Content to the Script to check the Usage of the root filesystem and Sent an alert E-mail
```
source ./variables.sh

if (( USAGE > THRESHOLD )); then
    echo "Check your Gmail Inbox... An E-mail is being sent..."

    if echo -e "Dear Gohary,\n\nAn alert for high disk space usage on the root filesystem has been detected for "$USAGE"% usage.\n\nBest regards,\nUbuntu" | mail -s "Alert: High Disk Space Usage" ahmedelgohary96@gmail.com; then
        echo "The email has been sent successfully."
    else
        echo "Failed to send the email."
    fi
fi
```
![image](https://github.com/user-attachments/assets/b7bcbc15-3763-4ced-980d-77b058de33c8)

- Change the permission of the script
```bash
chmod +x disk_space_alert.sh
```
- Check the root filesystem usage
```bash
df -h /
```
![image](https://github.com/user-attachments/assets/e6afd2f1-cd9d-44ac-8102-b553d706607d)
- Run the script
```bash
source ./disk_space_alert.sh
```
## 5. Create a cron job to run the script
```bash
crontab -e
```
- Add the following line to run the script everday at 5:00 PM (with the full path of the script) 
```
0 17 * * * ./home/mav/ivolve/Linux/Lab-2/disk_space_alert.sh
```
![image](https://github.com/user-attachments/assets/ae10d7f3-9084-49d6-a885-97d2b24e5d7b)
##
# I created a script to automate the process, eliminating the need to run each command manually.
