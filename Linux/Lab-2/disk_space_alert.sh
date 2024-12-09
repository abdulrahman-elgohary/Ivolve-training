source ./variables.sh

if (( USAGE > THRESHOLD )); then
    echo "Check your Gmail Inbox... An E-mail is being sent..."
    
    if echo -e "Dear Gohary,\n\nAn alert for high disk space usage on the root filesystem has been detected for "$USAGE"% usage.\n\nBest regards,\nUbuntu" | mail -s "Alert: High Disk Space Usage" ahmedelgohary96@gmail.com; then
        echo "The email has been sent successfully."
    else
        echo "Failed to send the email."
    fi
fi
