#!/bin/bash 
<<<<<<< HEAD
#The Script will install the required packages
#You need to change the values of EMAIL and PASS vairiables in variables.sh
=======
#Change the value of variables in variables.sh script
>>>>>>> ae9c258c8213ec3f3eab2bc2f117bc9f6328ef16
source ./variables.sh

sudo apt update -y

sudo apt install msmtp mailutils msmtp-mta -y

sudo systemctl enable msmtpd 
sudo systemctl start msmtpd

cat <<EOF > ~/.msmtprc
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
EOF
#The ' ' between EOF to make the variable USAGE does not expand in the this script but in the second script
cat <<'EOF' > disk_space_alert.sh
source ./variables.sh
if (( USAGE > THRESHOLD )); then
    echo "Check your Gmail Inbox... An E-mail is being sent..."
    
    if echo -e "Dear Gohary,\n\nAn alert for high disk space usage on the root filesystem has been detected for "$USAGE"% usage.\n\nBest regards,\nUbuntu" | mail -s "Alert: High Disk Space Usage" ahmedelgohary96@gmail.com; then
        echo "The email has been sent successfully."
    else
        echo "Failed to send the email."
    fi
fi
EOF

chmod +x disk_space_alert.sh
chmod 600 ~/.msmtprc
echo "***** Add the full path of the script to a cron job using the command crontab -e *****"
