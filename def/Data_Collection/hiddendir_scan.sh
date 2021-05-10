#!/bin/bash 
# 
# Description: Search for hidden directories in the file system 
# 
# Usage: supply: hiddendir_deepsearch.sh <directory> ;the system will then search for 
# --for dir starting with '.'

printf "Please provided a file path to begin the deepsearch. \n"

while true
do
        if ! IFS= read -r dir_choice #variable for the user's input
        then
                echo "ERROR: END OF INPUT!" >&2 #condidional to ensure proper user input...possible limit
                exit 2
        elif [ ! -d "$dir_choice" ]
        then
                printf "The option you provided is not a directory or file-path, please try again. \n"

        elif [ -d "$dir_choice" ]
        then
                printf "Initiating search...\n"
                break
        fi
done

tput sc            # save pointer/reference to current terminal line
erase=$(tput el)   # save control code for 'erase (rest of) line'



# init some variables; get a count of the number of files so we can pre-calculate the total length of our status bar

modcount=20
filecount=$( find "$dir_choice" -type d -name '.*'| wc -l)

# generate a string of filecount/20+1 spaces (35+1 for my particular /bin)

# conditional to scale size of the load bar based on some fixed value/limit 'x' where, x=10000
# this will also have to change the value of modcount 

if (( $filecount > 10000 )) 
then 
        modcount=$(( modcount * 20 ))

elif (( $filecount > 1000000 )) 
then 
        modcount=$(( modcount * 200 ))
fi


barspace=

for i in $(seq 1 $(( ${filecount} / ${modcount} + 1 )) )
do
        barspace="${barspace} "
done

while read -r filename 
do
        filecount=$((filecount+1))

        tput rc    # return cursor to previously saved terminal line (tput sc)

        # print filename (1st line of output); if shorter than previous filename we need to erase rest of line

        filename="${filename%$'\r'}"
        printf "file: ${filename}${erase}\n"
        ( printf "FILE NAME: "${filename##|*}" \n" |  realpath "$filename" ) >> hidden_dir_RESULTS.txt

        # print our status bar (2nd line of output) on the first and every ${modcount} pass through loop;

        if   [ ${filecount} -eq 1 ]
        then
                printf "[${barhash}${barspace}]\n"
                elif [[ $((filecount % ${modcount} )) -eq 0 ]]
        then
                # for every ${modcount}th file we ...

                barspace=${barspace:1:100000}         # strip a space from barspace
                barhash="${barhash}#"                 # add a '#' to barhash
                printf "[${barhash}${barspace}]\n"    # print our new status bar
        fi


done < <(find "$dir_choice" -type d -name '.*' | sort -V ) 

# finish up the status bar (should only be 1 space left to 'convert' to a '#')

tput rc

printf "Hidden Directoy Scan: -- Complete. Total matches identified: ${filecount} --                    \n"


if [ ${#barspace} -gt 0 ]
then
        #printf "\n"
        barspace=${barspace:1:100000}
        barhash="${barhash}#"
fi

printf "[${barhash}${barspace}]\n"