#!/bin/bash 
# 
# Description: Provide a general make-up/layout of target system 
# 
# Usage: ./x_ray or bash x_ray, a certain set of commands should run purely based on the 
# --the output of the osreveal command 

Linux_Sys_Cmds()
{ 
        # Linux system gathering cmds

        uname -a 
        cat /proc/cpuinfo 
        ifconfig 
        route 
        arp -a 
        netstat -a 
        mount 
        ps -e 
}

Windows_GitBash_Sys_Cmds() 
{ 
        # Windows system gathering cmds 

        uname -a 
        systeminfo 
        ipconfig 
        route print 
        arp -a 
        netstat -a 
        net share 
        tasklist 
} 

DumpInfo ()
{ 
        printf '<systeminfo host="%s" type="%s"' "$HOSTNAME" "$OSTYPE"
        printf ' date="%s" time="%s">\n' "$(date '+%F')" "$(date '+%T')"

        if [[ "$OSTYPE" == "Linux" ]] 
        then 
                Linux_Sys_Cmds 

        elif [[ "$OSTYPE" == "MSWin" ]] 
        then 
                Windows_GitBash_Sys_Cmds 
        fi


        printf "</systeminfo>\n"
}

OSTYPE=$(./osreveal.sh) # result is the os type
HOSTNM=$(hostname) 
TMPFILE="${HOSTNM}.info"
DumpInfo > $TMPFILE 2>&1  # system cmds run based on the OSTYPE value