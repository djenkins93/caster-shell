#!/bin/bash 
# 
# Descriprion: 
# Generate a live bar chart of live data
# 
# Usage: 
# <output from other script or program> | bash livebar.sh
# 
# MODS/ADDS: 1. max expected input value provided by the script 
# 2. create a live analysis of 'ioc.txt' file w/ current activity 
# 3. "watchlist"; allow for watchlist comparisons of ips or UID's 

#IMPORTED SCRIPTS 
TAILCOUNT=/home/chronos/user/xxx./caster/def/Log_Monitor/tailcount.sh

while getopts ':ifk*' opt; do 
        case "${opt}" in 
                i) # allows user to dictate the interval of the script 
                   # if no numerical value if provided then 'CYCLE' given 5 automatically
                        resp='^[0-9]+$' # create a var that controls the intervals 
                        export CYCLE=$2 # decl. provides 'tailcount.sh' access to the udef "$CYCLE"
                        declare -i cmd_array
                        cmd_array=("$@")

                        for a in "${cmd_array[@]}"
                        do 
                                if ! [[ $a =~ $resp ]] # ensure that numerical value is passed  
                                then 
                                        #continue
                                        break

                                elif [[ $a =~ $resp ]] && [[ $a != 0 ]] 
                                then 
                                       CYCLE=$a
                                fi
                                # CYCLE is given an intervalue by the user  
                        done
                        ;; 

                f)  
                # tail [ somefile ] | grep [ pattern ]
                        FILTER=YES
                        export pattern 
                        ;;

                k) 
                # activates "killswitch"; for timed run of the script  
                        ON=YES 
                        ;;

                M) # max input value  
                   # if the option is used it should activate a conditional 
                        if [ $# -lt 3 ] 
                        then 
                                echo "MAX LIMIT EXCEEDED" 
                                # DOSOMETHING
                        fi 
                        ;;

                *) # unknown/unsupported option given a value of error  
                        printf "Opition or argument provided, was not recognized.\n" 
                        exit 2
                        ;; 
        esac
done 

# conditional declaration based
if ! [[ -z "FILTER" ]] 
then 
        # pattern=" user def. patterned"  
        pattern=${2:-"2006"} # find a way to make this a custom variable...
fi 

# set default value for "CYCLE"
if [[ -z "$CYCLE" ]] 
then 
        CYCLE=5 # run in 5sec intervals 
fi 

function pr_bar () 
{ 
        local raw maxraw scaled 
        raw=$1 
        maxraw=$2 
        ((scaled=(maxbar*raw)/maxraw))
        ((scaled == 0)) && scaled=1 
        for((i=0; i<scaled; i++)); do printf '#' ; done
        printf '\n'

} # pr_bar


maxbar=60 # largest no. of char in the bar 
MAX=60 

function raw_data() 
{
        while read dayst timst qty
        do 
                if (( qty > MAX )) 
                then 
                        let MAX=$qty+$qty/4 # allow more room 
                        echo "          **** rescaling: MAX=$MAX"
                fi 

                # here is where the filter modification needs to go...200609 12:57:02(!) 
                printf '%6.6s %6.6s %4d:' $dayst $timst $qty
                pr_bar $qty $MAX

        done < <( if ! [[ -z $ON ]]; then ./killswitch.sh; else ./$TAILCOUNT;  fi ) 
} 

# Conditional dictates filtered or unfiltered output  
# --filtered output triggered by FILTER flag 

if ! [[ $FILTER ]] 
then 
        raw_data 

elif [[ $FILTER ]] 
then 
        raw_data | egrep --color=always --line-buffered "$pattern"
fi 
