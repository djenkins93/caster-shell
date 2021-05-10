#!/bin/bash -x
# 
# Description: "killswitch" aka "killed-in-action" script 
# 
# Usage: kia <#m,#s,#h> <filename> 

        # run default timed version of the script 
        # TMR; be the custom user input  
        # TMR=${1:-1m}
        timeout 1m bash tailcount.sh # run a timed version of a live script 