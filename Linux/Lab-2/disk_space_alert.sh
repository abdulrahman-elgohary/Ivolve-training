#!/bin/bash

USAGE=$(df -h / | tail -1 | awk '{print $5}' | tr -d %)
THRESHOLD=10

if (( USAGE > THRESHOLD )); then 
echo "Check your Gmail Inbox  .. An E-mail is being send"
echo -e "An Alert for a high disk space on the root filesystem" | mail -s "Alert" ahmedelgohary96@gmail.com
fi


