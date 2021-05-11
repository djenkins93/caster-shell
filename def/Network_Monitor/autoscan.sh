#!/bin/bash 
# 
# Descriptin: perform an auto-portscan, 'hostlist' should be provided by user  
# 
# Usage: autoscan.sh 
# 
# (!) Warning: currently still under construction


./scan.sh < hostlist 

FILELIST=$(ls scan_* | tail -2)
FILES=( $FILELIST ) 

TMPFILE=$(tempfile)

./fd2.sh ${FILES[0]} ${FILES[1]} > $TMPFILE 

if [[ -s TMPFILE ]] # non emptu 
then 
        echo "mailing todays port differences to $USR" 
        mail -s "today's port differences" $USR < $TMPFILE 
fi 

rm -f $TMPFILE