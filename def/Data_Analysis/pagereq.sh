#!/bin/bash 
# 
# Description:
# --count the number of page request for given ipaddr. using the bash shell
#
# Usage:
# --pagereq <ipaddr.> < inputfile
# (eg): bash pagereq.sh 192.168.0.37 < access.log | sort -rn | head -5 
#
# MODS:04.01.2020
# 1. Change associative array to an index array
# 2. Convert the ipaddr into a 10-12 digit number
# -- DO NOT have leading zeroes for the num. conv. for example 10.124.16.3 >> 1001240016003
# -- Need to find a way ro view the current IP address
# May need to fully setup the proxy-server so that access logs can be observed

# declare -a cnt
declare -A cnt # in order to alter the array simply use "-a" for the flag
while read addr d1 d2 datim gmtoff getr page therest
do
        if [[ $1 == addr ]]; then let cnt[$page]+=1 ; fi
done


for id in ${!cnt[@]}
do
        # create cond. to change '.' to '0' whenever encountered
        # there should be no more than 3 total 0's
        # figure out which element is the ipaddr see the txt

        printf "%8d %s\n" ${cnt[$id]} $id
done

#printf "\n"
#printf "ADDR: $addr \n" # need to find a way to print the addr.
#printf "ID: $id \n "