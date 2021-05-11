#!/bin/bash 
# 
# Description: preform a banner snatch on email port (simple mail protocol) 
# 
# Usage: ./smtpconnect.sh 
# ./smtpconnect.sh <host_ip> 

exec 3<>/dev/tcp/"$1"/25 
echo -e 'quit\r\n' >&3 
cat <&3 
