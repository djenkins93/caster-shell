#!/bin/bash
# 
# Description: Generate horizontal bar char based data provided 
#
# Usage: ./histogram.sh 
#        

# option to change the size of graph bar display
while getopts ':fs*' opt; do 
        case "${opt}" in 
                f) # allow inputfile for ipaddr. watch list 
                        FLAG_CHK=YES # use to check ipfile is actually a file
                        ipfile="${@: -1}"
                        ;;
                s) # change the size of the pr_bar 
                        declare -i cmd_array # decalre an integer based array 
                        cmd_array=("$@") # declare array that holds cmd_line arguments 
                        re='^[0-9]+$' 

                        for i in "${cmd_array[@]}"
                        do 
                                if ! [[ $i =~ $re ]] # if numerical value not found skip case
                                then 
                                        #continue
                                        break

                                elif [[ $i =~ $re ]] && [[ $i != 0 ]] 
                                then 
                                        MAXBAR=$i 
                                fi
                                # MAXBAR size based on 'i' numerical positional parameter 
                        done
                        ;; 
                *) #unknown/unsupported optiion  
                   #error message provided by getopts 
                        exit 2
                        ;;

        esac
done 
shift $((OPTIND - 1))

function pr_bar () 
{ 
        local -i i raw maxraw scaled 
        raw=$1
        maxraw=$2 
        ((scaled=(MAXBAR*raw)/maxraw))
        # min size gurantee 
        ((raw > 0 && scaled == 0)) 

        for((i=0; i<scaled; i++)) ; do printf '#' ; done 


        # prints the number of occr. value at the end each pr_br
        printf '%-.20s ' "   "  "${RA[${labl}]}"
        printf '\n'

} #pr_bar


# used to identify designated ip(s) 
function watchlist () 
{ 
        ipfile_arr=()
        flagged_ip=()
        ipmatch_cnt=0 # track the number of ip matches 

        # ipaddr. array based on user ipfile 
        while read ipaddr 
        do 
                ipfile_arr+=( $ipaddr )

        done < "$ipfile"

        # begin array comparison
        for x in "${ipfile_arr[@]}" 
        do 
                for y in "${!RA[@]}"
                do 
                        if [ "$x" = "$y" ] #&& [ "${#flagged_ip[@]}" -le "${#ipfile_arr[@]}" ] 
                        then 
                                # setup arr. to hold all matching ipaddr(s) 
                                let ipmatch_cnt+=1
                                flagged_ip+=( $x )
                        fi
                done
        done 

        if [ $ipmatch_cnt == 0 ]
        then 
                printf "NO MATCHES IDENTIFIED from user input file." 
        fi

printf "%s\n" "${flagged_ip[@]}"
echo "-----------------------------------------"
printf "TOTAL # OF IP_MATCHES: $ipmatch_cnt \n"
} #watchlist

#
# main 
# 

declare -A RA 
declare -i MAXBAR max 
max=0 
#MAXBAR=50 

if [[ -z "$MAXBAR" ]] # check if MAXBAR is empty
then 
        MAXBAR=50 # default value of bar
fi

while read labl val
do 
        let RA[$labl]=$val
        # retain the largest value; for scaling 
        (( val > max )) && max=$val 
done 


# display min/max value(s) based on comparison
function data_rank ()
{
        # May need to conv. assoc. arr to an index arr. 
        # --index array of the numerical elemets can then be compared 

        printf '\n'

        # workaround for assoc. array values 
        for i in "${!RA[@]}"; do firstkey="$i"; break; done

        max_val="${RA[$firstkey]}"
        min_val="${RA[$firstkey]}"

        for i in "${RA[@]}"
        do 
                (( "$i" > "$max_val" )) && max_val="$i" 
                (( "$i" < "$min_val" )) && min_val="$i"
        done

        echo "CURR.MAX: $max_val" 
        echo "CURR.MIN: $min_val"
}

# Create a cond. check for the 'watchlist' file
# Conside deletion of all code below 

#if [[ $FLAG_CHK ]] 
#then 
        #printf "Please provide an input_file for watchlist for analysis \n"
        #read -e -p ipfile
        #ipfile="$(echo ${@: -1})"
        #$ipfile="$( cat $ipfile )"
        # make sure the file provided is a file--preferably a text file
        #while ! [ -f $ipfile ] # need to create a check for '.txt'
        #do
        #       printf "Input provided is not a known file. Try again? \n"
        #       read $ipfile
        #done
#fi


# scale and print it 
printf "\n"
for labl in "${!RA[@]}" 
do 
        printf '%-20.20s ' "$labl" 
        pr_bar ${RA[$labl]} $max 
        if [ "$labl" = "x" ] 
        then 
                echo "MATCH"
        fi
        # here is where we need to print the num of occurences related to each ip addr. 
done

data_rank # list MIN/MAX of data

printf "\n"
echo "(!) WATCHLIST IP'S MATCHES IDENTIFIED (!): " 
echo "-----------------------------------------"
watchlist # display ip watchlist comparison