#!/bin/bash 
# 
# Description: Gather registry key information of 'windows' OS based system 
#
# Usage: Standard "./" or  <command> implementation on the system of interest collects logs
# --of interests to defensive operations 
# 
# BUG(02.21.20): modification--'export' cmd potentially used for 'reg query...' 
# SYNTAX:--reg export [key] [file_name] , need to create a file such as '${SYSNAM}_regkey_info.txt'

SYSNAM=$(hostname)

SYSNAM_REGKEY=$(reg query HKEY_LOCAL_MACHINE | sort -V) # allocate the registry info to variable 
$SYSNAM_REGKEY > $SYSNAM_regkey.info 

printf "Registry Keys Info Located: -- Complete. -- \n"
printf "See $SYSNAME_regkey.info for results. \n" 