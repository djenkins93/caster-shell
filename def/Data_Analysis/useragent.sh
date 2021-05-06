#!/bin/bash 
# 
# Description: Search through logs for an unkmowm user agents
# 
# Usage: ./useragent < <input file>
#
# MOD: 1.Create a variale that can obtain a file name for white-list hosts
# --2.Create an option '-f' to take a file input w/o having to use the input char '<'
#
# BUGS: 03.25.2020 
# 1. currenlty functioning correctky but not providing the correct output 
# --curr. output: <ipaddr.>
# --desr. output: <ipaddr.> <useragent/browser>
#
# NOTE: May need to design a sample known.hosts/known_hosts file for testing
# ^ sample useragent.txt file created 

while getopts ':f*' opt; do 
        case "${opt}" in 
                f) # option to allow for file input 
                        ADD_FILE=YES 
                        ;; 

                *) #unknown/unsupported optiion  
                   #error message provided by getopts 
                        exit 2
                        ;;
        esac
done 
shift $((OPTIND - 1))

defaultlogfile="default_useragents.txt"

# activate conditional based on the flag provided by the user 

if [[ $ADD_FILE ]] 
then 
        echo "FLAG ACTIVE" 
        echo "Please provide an input file:"

        # (!)03.26.2020: may need to provide 'input_file' w/ a pos.param. value 
        read input_files
        
        if ! [[ -f $input_file ]] 
        then 

                while ! [[ -f $input_file ]] 
                do 
                        echo "FILE NOT FOUND, would you like to try again: (yes,y or no, n) ?"
                        read reply 

                        # (!)03.26.2020: condiser making the 'reply' non-case sensitive 
                        # -- see the 'shopt' command 

                        if [[ "$reply" == "yes" ]] || [[ "$reply" == "y" ]] 
                        then 
                                read $input_file
                                KN_HOSTS="$input_file"

                        elif [[ "$reply" == "no" ]] || [[ "$reply" == "n" ]] 
                        then 
                                break
                        else 
                                echo "Input NOT VALID: plese provide one of the listed responses" 
                                read $reply
                        fi
                done

        elif [[ -f $input_file ]] 
        then 
                KN_HOSTS=$input_file
        fi
else
        echo "NO FLAG active" 
        KN_HOSTS=${1:-default_useragents.txt} # Variable for adding a known.host/know_hosts file
fi 

KN_HOSTS=${1:-useragents.txt} # Variable for adding a known.host/know_hosts file 

printf '\n'

if ! [[ -f $KN_HOSTS ]] 
then 
        echo "NOT A FILE: $KN_HOSTS" 

elif [[ -f $KN_HOSTS ]]
then 
        echo " this is a FILE: $KN_HOSTS" 

fi 

function mismatch () 
{ 
        local -i i 
        for ((i=0; i<$KNSIZE; i++)) 
        do 
                [[ "$1" =~ .*${KNOWN[$i]}.* ]] && return 1 
        done 
        return 0 
} 

# read up the known ones 
readarray -t KNOWN < "useragents.txt" 
KNSIZE=${#KNOWN[@]} 

awk -F'"' '{print $1, $6}' | \
while read ipaddr dash1 dash2 dtstamp delta useragent 
do 
        if mismatch "$useragent" 
        then 
                echo "anomaly: $ipaddr $useragent" 
        fi 
don