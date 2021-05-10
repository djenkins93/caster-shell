#!/bin/bash
# 
# lnxlog.sh
#
# Description: Gather copies of linux log files on Linux based OS systems 
# 
# Usage: lnxlogs.sh [-z] 
# -z Tar and zip the output 
# (!) 02.21.20 BUG: 'tar' cannot compress the directory, also seems to be an issue with creation 'LOGDIR' 

TGZ=0 
if (( $# > 0 )) 
then 
        if [[ ${1:0:2} == '-z' ]]
        then 
                TGZ=1   # tgz flag to tar/zip the log files 
        shift 
        fi 
fi 
SYSNAM=$(hostname) 
LOGDIR=${1:-/tmp/${SYSNAM}_lnx_logs} # location for exfil 


mkdir -p $LOGDIR 
cd ${LOGDIR} || exit -2 

cp -a /var/log/. ~/caster/defense/Data_Collection #used copy all logs including hidden directories

if (( TGZ == 1 )) 
then 
        tar -czvf ${SYSNAM}_lnx_logs.tgz 
        printf "Log files compressed \n" # indicate to user that the log files have been compressed 
fi 

# Indiciate the end of the script 
printf "Log file Transfer: -- Complete. -- \n"