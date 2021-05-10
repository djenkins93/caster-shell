#!/bin/bash 
# 
# Descritpion: 
# Count lines every n sec(s) 
#
# Usage: ./tailcount.sh [filename] "or" bash tailcount.sh [filename]
# filename: passed to looper.sh (see code ref.)
#  

function cleanup () 
{ 
        [[ -n $LOPID ]] && kill $LOPID 
}

trap cleanup EXIT

# Allow tail counr ro user looper script 
LOOPER=/home/chronos/user/xxx./caster/def/Log_Monitor/looper.sh

#bash looper.sh $1 & # modify to pass output of 
bash $LOOPER $1 &
LOPID=$! 

# give it the chance to start
sleep 3 

# cond. is needed to prevent  a run-away process  
# if "CYCLE" has null value award default  

if [[ -z "$CYCLE" ]] 
then 
        CYCLE=5 # given default val. of 5sec(s) 
fi 

while true 
do 
        kill -SIGUSR1 $LOPID 
        sleep $CYCLE # variable controls the interval-speed 

done >&2 