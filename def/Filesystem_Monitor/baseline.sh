#!/bin/bash 
# 
# Descripition: used to generate a master-hash baseline for all files in a particula
# Usage: ./baseline.sh [ -d path ] file1 [ file2 ] OR baseline.sh [ -d path ] file1 [ file2 ] 
#
# MODS/BUGS: 
# 1. What could be done "parallelize" any part of the code for faster performance? (TIP: use the '&' order to run a task in the background)  
# 2. May want to consider putting in a script to erify that a 'dir' is actually provided with opt 'd...later for now focus your attention on the script 
# --you will likely want to use the "&" on specific methods in the code...particularly associated w/ "loops" 

function usageErr()
{ 
        echo 'usage: baseline.sh [ -d path ] file1 [file2]' 
        echo 'creates or compares a baseline from path ' 
        echo 'default for path is /'
        exit 2
} >&2 

function overwriteCHK() 
{ 
        # PREVENT fILE OVERWRITE 
        if [[ -e "$BASE" ]] && [[ -f "$BASE" ]] 
        then 
                DOA=$( stat -c "%x" "$BASE") 
                DOM=$( stat -c "%y" "$BASE")

                echo "(!)WARNING(!): File by name '"$BASE"' ALREADY EXSISTS."
                echo "------------------------------------------------------"
                echo "Prev. Date of Access: $DOA " 
                echo "Prev. Date of Modification: $DOM"
                echo "------------------------------------------------------"
                echo "Are you sure you wamt OVERWRITE '"$BASE"'? (Y/N)"

                read CHOICE 

                #while [ $CHOICE != "y" ] || [ $CHOICE != "Y" ] || [ $CHOICE != "n" ] || [ $CHOICE != "N" ]
                while ! [ "$CHOICE" == "y" ] && ! [ "$CHOICE" == "n" ]
                do 
                        "Please enter one of the provided choices. (Y/N)"
                        read $CHOICE
                done 

                # 'if' CHOICE is yes then continue 
                if [ "$CHOICE" == "y" ] || [ "$CHOICE" == "Y" ] 
                then 
                        #continue 
                        return

                # 'elif' CHOICE is no, then exit0 
                elif [ "$CHOICE" == "n" ] || [ "$CHOICE" == "N" ]
                then 
                        # don't overwrite the file 
                        exit 0  
                fi 
        fi
}

#(!)PRLZ. (1) 
function truePath() 
{ 
        for i in "${DIR[@]}"  
        do 
                # find the real value of each element of an array 
                j=$( realpath -e "$i" ) # consider rewriting due to creation of a sub-shell 
                absDIR+=( "$j" ) 
        done 
}

#function pathCheck()
#{ 
        # use this function to check the path to file -- 
        # from <path>.../$ALTFN to <path>.../$FN 
        # where 'A=<path>.../$ATLFN'
        # and 'B=<path>.../$FN' , has to be obtained via 'sed' cmd 
#}


#(!)PRLZ. (2)
function dosumming() 
{
        # Primary function for generating master-hash baselines
        find "${DIR[@]}" -type f | xargs -d '\n' sha1sum
}

function parseArgs()
{ 
        while getopts "d:" MYOPT 
        do 
                # no check for MYOPT since there is only one choice 
                DIR+=( "$OPTARG" ) 
        done 
        shift $((OPTIND-1))

        # no arguments? too many? 
        (( $# == 0 || $# > 2 )) && usageErr

        (( ${#DIR[*]} == 0 )) && DIR=( "/" )
}

declare -a DIR 
declare -a absDIR
parseArgs $*

truePath

# 2nd shift is need to obtain correct args
shift $((OPTIND-1))

BASE="$1"
B2ND="$2"

if (( $# == 1 ))  #only 1 arg.
then 
        # creating a baseline ("BASE")
        overwriteCHK
        dosumming > "$BASE" &
        exit 
fi 

if [[ ! -r "$BASE" ]] 
then 
        usageErr 
fi 

# if 2nd file exsists just compare the two 
# else create/fill it 

# CREATES HASH BASED ON INPUT AT '$1'
# (!)PRLZ. (3)
if [[ ! -e "$B2ND" ]] && [[ ! -z "$B2ND" ]] 
then 
        echo creating "$B2ND" 
        dosumming > "$B2ND"  
fi 


# this creates two files using the sha1sum 
declare -A BYPATH BYHASH INUSE # assoc. arrays 

# load up the first file as the baseline
# (!) 2020.12.16: The following 'while-loop' may be the best area to estb.
# --parallelization, also do so for ANY files that aren't being  

while read HNUM FN 
do 
        BYPATH["$FN"]=$HNUM 
        BYHASH[$HNUM]="$FN" 
        INUSE["$FN"]="X" 

done < "$BASE"

printf '<filesystem host="%s" dir="%s">\n' "$HOSTNAME"  "${absDIR[*]}"

while read HNUM FN 
do 
        WASHASH="${BYPATH[${FN}]}"
        if [[ -z $WASHASH ]] 
        then 
                ALTFN="${BYHASH[$HNUM]}"
                F1PATH=$ALTFN

                if [[ -z $ALTFN ]] 
                then 
                        printf '  <new>%s</new>\n' "$FN"
                else
                        # create a conditional to check the path to the "relocated" file 
                        # "IF" <some-pattern> matches <another-pattern>
                        # use the 'sed' command in-prder to filter the output 


                        [[ ! -z "$FN" ]] && F2PATH=$FN # award the proper file path value to variable 

                        # IF "F1PATH" equal to "F2PATH" THEN perform 'sed' edit of the output 
                        if [[ $F1PATH==$F2PATH ]] 
                        then 
                                # printf... | sed <options> 
                                # OR printf | (*edit w/ 'sed' *)  

                                printf '  <relocated orig="%s">%s</relocated>\n' "$ALTFN" "$FN" | sed -e s/*// -e s?./??
                                printf '  **NOTE: Original File & Relocated file are in the same DIR**'
                                echo"" 

                        else 
                                printf '  <relocated orig="%s">%s</relocated>\n' "$ALTFN" "$FN"
                        fi 

                        #printf '  <relocated orig="%s">%s</relocated>\n' "$ALTFN" "$FN" 
                        INUSE["$ALTFN"]='_' # mark this as seen 
                fi 
        else
                INUSE["$FN"]='_'
                if [[ $HNUM == $WASHASH ]] 
                then 
                        continue; #do nothing just keep moving 
                else 
                        printf '  <changed>%s</changed>\n' "$FN" 
                fi 
        fi

# CHECK for FILE to <path>.../<file1>" 
# CHECK value of 2nd target before assigning it to a VAR 

done < "$B2ND"  

for FN in "${!INUSE[@]}" 
do 
        if [[ "$INUSE[$FN]}" == 'X' ]] 
        then 
                printf '  <removed>%s</removed>\n' "$FN"
        fi 
done 

printf '</filesystem>\n'

test_txtEDIT=$( echo "ALTFN: $F1PATH" | sed -e s/*// -e s?.*/?? )

echo " "
echo "FIRST_FILE: $F1PATH"
echo "SECOND_FILE: $F2PATH"
echo "editTEXT: $test_txtEDIT"

