#!/bin/bash 
# 
# Descripition: Peform a comparison of the 
# of the output of the "portscan.sh" 
#
# Usage: ./scan_diff.sh <scan_file1> <scan_file2>  
NotInList () 
{ 
        for port in "$@" 
        do 
                if [[ $port == $LOOKFOR ]] 
                then 
                        return 1 
                fi 
        done 
        return 0
} 

while true 
do 
        read aline <&4 || break 
        read bline <&5 || break 

        # if [[ $aline == $bline ]]; then continue; fi 
        [[ $aline == $bline ]] && continue 

        HOSTA=${aline%% *} 
        PORTSA=( ${aline#* } )

        HOSTB=${bline%% *} 
        PORTSB=( ${bline#* } )

        echo $HOSTA

        for porta in ${PORTSA[@]]} 
        do 
                LOOKFOR=$porta NotInList ${PORTSB[@]} && echo " closed: $porta" 
        done 

        for portb in ${PORTSB[@]}
        do 
                LOOKFOR=$portb NotInList ${PORTSA[@]} && echo "    new: $portb"
        done

done 4< ${1:-day1.data} 5< ${2:-day2.data}
# day1.data and day2.data are default names to make it easier to test 