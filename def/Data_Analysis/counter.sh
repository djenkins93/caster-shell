#!/bin/bash
#
# Description: Sum total of the field values for each uniq field
#
# Usage: ./summer.sh
#       input format: <name> <number>

declare -A cnt # assoc. array
while read item xtra
do
        if [ -z "$item" ]
        then
                continue

        elif [ ! -z "$item" ]
        then
                let cnt[$item]++ # count each item within the assoc. array
        fi
done

# display the items counted
# do so for each item in the (key, value) assoc. array

for item in "${!cnt[@]}"
do
        printf "%-15s %8d\n" "$item" "${cnt[${item}]}"
done