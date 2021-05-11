# !/bin/bash 
# 
# Description: A script that automatically pull banners from HTTP, SMTP, and FTP servers
# 
# Usage: ./bannersnatch.sh hostname [scratch_output_file] 
# --default scratch-file name is, "bs_scracth.file"...may want to add date and .txt extension 

isportopeni () 
{ 
        (( $# < 2 )) && return 1 
        local host port 
        host=$1 
        port=$2 
        echo >/dev/null 2>&1 < /dev/tcp/${host}/${port} 
        return $? 
} 

cleanup () 
{ 

        rm -f "$SCRATCH"
} 

ATHOST="$1" 
SCRATCH="$2"
if [[ -z $2 ]] 
then 
        if [[ n $(type -p tempfile) ]] 
        then 
                SCRATCH=$(tempfile) 
        else 
                SCRATCH='bs_scratch.file'
        fi 
fi 

trap cleanup EXIT 
touch "$SCRATCH"

if isportopen $ATHOST 21 #FTP Port 
then 
        exec 3<>/dev/tcp/${ATHOST}/21 
        echo -e 'quit\r\n' >&3 
        cat <&3 >> "$SCRACTH" 
fi 

if isportopen $ATHOST 25 #