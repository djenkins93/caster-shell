# !/bin/bash 
# Program name: hashsearch.sh 
#
# Description: recursively search a given directory for a file
# that matches a given SHA-1 and SHA-256 hash 
#
# Usage: hashsearch.sh <hash> <directory> <opition/flag> 
# "hash" -- SHA-1 has value to find 
# "directory" -- Top directory to start the search 
# "option/flag" -- the instant exit opition for the program 
# how to modify so options are provided to the user to quit 
# general cmd structre ... [command] [-options] [arguments]

# QUIT option to stop recusive search  
while getopts ':1*' opt; do 
        case "${opt}" in 
                1) #quit option, first option 
                        QUIT=YES 
                        ;; 
                *) #unknown/unsupported optiion  
                   #error message provided by getopts 
                        exit 2
                        ;;

        esac
done 
shift $((OPTIND - 1))

HASH=$1
DIR=${2:-.} 

# create a full file-path output for the user 
# this code can potentially be consolidated by making use of the 'realpath' command 

HASH_STR=$HASH # create an array based on hash string 
HASH_SIZE=$(( ${#HASH_STR}/2 )) # var for size of the hash in byte(s) hash-lenght/2 

printf "\n"
printf "HASH string length: ${#HASH_STR} \n"
printf "HASH byte size: $HASH_SIZE \n" # size of the hash-string in bytes 
printf "\n"

if  [[ $HASH_STR == 0 ]] ||  [[ $HASH_SIZE == 0 ]] 
then 
        printf "A hash is required to use tool. Please submit a hash and try again. " 
        printf "\n"
        exit 0
fi



function mkabspath () 
{ 
        if [[ $1 == /* ]] 
        then 
                ABS=$1
        else 
                ABS="$PWD/$1"
        fi

        ABS=${ABS/.\/} || ABS=${ABS/..\/} # get rid of the "." prior to the filename  
}


# perform checksum based on size of HASH 
function checksum_choice () 
{ 
        if [[ $HASH_SIZE == 20 ]] 
        then 
                #printf "Performing sha1sum search based on hash. \n"
                THISONE=$(sha1sum "$fn")

        elif [[ $HASH_SIZE == 28 ]] 
        then 
                #printf "Performing sha224sum search based on hash. \n"
                THISONE=$(sha224sum "$fn") 

        elif [[ $HASH_SIZE == 32 ]]
        then 
                #printf "Performing sha256sum search based on hash. \n"
                THISONE=$(sha256sum "$fn")

        elif [[ $HASH_SIZE == 48 ]] 
        then 
                #printf "Performing sha384sum search based on hash. \n"
                THISONE=$(sha384sum "$fn")

        elif [[ $HASH_SIZE == 64 ]] 
        then 
                #printf "Performing sha512sun search based on hash. \n"
                THISONE=$(sha512sum "$fn")
        fi
}

printf "\n"
printf "Initiating HASH search... \n" 
#printf "One moment. \n" 

#
# main 
# 

find $DIR -type f | 
while read fn 
do 
        checksum_choice
        THISONE=${THISONE%% *} 

        if [[ $THISONE == $HASH ]] 
        then 
                mkabspath "$fn" 
                printf "File path successfully located for the user supplied hash. \n"
                #printf "\n"
                echo "FILE NAME:${ABS##*/}" # clean filename output
                echo "FILE PATH:$ABS" # file patih output.

                if (( $? == 0 )) && [[ $QUIT ]] 
                then 
                        exit 0
                fi 
        fi 

done

