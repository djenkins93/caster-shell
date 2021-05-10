#!/bin/bash
# 
# Descritpion: Organizes a dashboard of script output to make the information provided 
# --security information easier to digest 
#
# --(!)MOD: Allow the user to sepcify log entries to be monitored 
# var $L_ENTRY1 $L_ENTRY2  
# each variable needs to be equivalent to postional parameter: ./webdash [log_entry1] [log_entry2]
# --verify that the variable actually exsists...conditional, if does proceed if not use default path 
# --(i.e.) /var/log/syslog 

# NEEDED CONSTANT STRINGS  
UPTOP=$(tput cup  0 0)  
ERAS2EOL=$(tput el)
REV=$(tput rev) 
OFF=$(tput sgr0) 
SMUL=$(tput smul) 
RMUL=$(tput rmul) 
COLUMNS=$(tput cols)
# CREATING DASH BORDER'------------'
DASHES=$( printf %"$COLUMNS"s |tr " " "-" )

function prSection() 
{ 
        local -i i 
        for ((i=0; i < ${1:-5}; i++)) 
        do 
                read aline 
                printf '%s%s\n' "$aline" "${ERAS2E0L}" 
        done 
        printf '%s%s\n%s' "$DASHES" "${ERAS2EOL}" "${ERAS2EOL}" 
} 

function cleanup()
{ 
        if [[ -n $BGPID ]]
        then 
                kill %1 
                rm -f $TMPFILE 
        fi 
} &> /dev/null 

trap cleanup exit 

#launch the bg process 
TMPFILE=$(tempfile)
# (!) --02/15/21 (ERROR): need to fix 'livebar.sh' also fix the '/var/log/syslog' issue  
# (!) --02/17/21 Need to call the 'tailcount.sh' script using a path to 'tailcount.sh'
TAILCOUNT=/home/chronos/user/xxx./caster/def/Log_Monitor/tailcount.sh
LIVEBAR=/home/chronos/user/xxx./caster/def/Log_Monitor/livebar.sh # this will be a call to the originalrfile libssl.so.1.0.0:

#{ bash tailcount.sh $1 | \ 
{ bash $TAILCOUNT $1 | \
        #bash livebar.sh > $TMPFILE ; } & 
        bash $LIVEBAR > $TMPFILE ; } & 
BGPID=$! 

clear
while true 
do 
        printf '%s' "$UTOP"
        # heading: 
        echo "${REV} -- Security Dashboards${OFF}" \
        | prSection 1
        #-------------------------------------------------
        { 
                printf 'connections:%4d         %s\n' \
                        $(netstat -an | grep 'ESTAB' | wc -l) "$(date)" 
        } | prSection 1 
        #-------------------------------------------------
        # (!)ERROR: occurring after the previously executed lines of code 
        tail -5 /var/log/eventlog | cut -c 1-16,45-105 | prSection 5
        #-------------------------------------------------
        { echo "${SMUL}yymmdd${RMUL}"   \
                "${SMUL}hhmmss${RMUL}" \
                "${SMUL}count of events${RMUL}"
         tail -8 $TMPFILE
        } | prSection 9 
        sleep 3 
done