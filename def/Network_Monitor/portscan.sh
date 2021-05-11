#!/bin/bash 
# 
# Description: Blue print frame work for the portscan
#
# MOD(s):20.18.08 

# CHECK IF INPUT IS A FILE (LIST OF IP'S) 
file_check()
{ 
        if [[ -f $host ]] 
        then 
                LISTFLAG=YES
                echo "input is a FILE." 
        fi
}

# CUSTOM PORT SELECTION
custom_port_select()
{
        # USER SPECIFIED PORT SCAN

                echo "Would you like to scan a specific PORT-NUMBER or PORT-RANGE?"
                echo "1. PORT-NUMBER"
                echo "2. PORT-RANGE"

                read CHOICE

                # perform a CHOICE check
                while ! [ "$CHOICE" == 1 ] && ! [ "$CHOICE" == 2 ]
                do
                        echo "Please Select one of the provided choices"
                        read CHOICE
                done

                # SCAN CUSTOM SINGLE PORT-NUMBER
                if [[ $CHOICE == 1 ]]
                then
                        echo "Please enter a specific port number."
                        SCAN_TYPE="single-port"
                        read PORT_NUM

                        while ! [[ $PORT_NUM =~ ^[0-9]+$ ]]
                        do
                                printf '%s' "HOSTNAME: $host"
                                echo ""
                                "Please enter a positive interger value."
                                read PORT_NUM
                        done
                fi

                # SCAN CUSTOM PORT-RANGE
                if [[ $CHOICE == 2 ]]
                then
                        # do a port-range scan
                        echo "ENTER START (inclusive)"
                        SCAN_TYPE="port-range"
                        read START

                        echo "ENTER an END (exclusive)"
                        read END
                fi
}


# CONTROL THE TYPE OF SCAN
scan()
{
        # Run a specific scan based on the "PORT_TYPE" variable
        echo "" 
        hit=0

        # FORMAT OUTPUT  
        # CHANGE PORT OUTPUT TO SET BASED OPEN-PORTS

        if ! [ -f $host ] 
        then
                printf '%s' "HOSTNAME: $host"  

        elif [ -f $host ] 
        then 
                printf '%s' "HOSTNAME: $line"
                #list_scan
        fi 

        echo "" # Print for spacing 
        printf "\e[1;5;101mCLOSED PORT(S):\e[25m\e[0m"

        # USER SELECTED BASED SCAN 
        if [[ $CHOICE == 1 ]] || [[ $CHOICE == 1 ]] && [[ -z $LISTFLAG ]] 
        then
                echo "PORT SELECTED SCAN."
                port=$PORT_NUM
                echo >/dev/null 2>&1 < /dev/tcp/${host}/${port}
                if (($? == 0)) ; then printf '%d' "OPEN: ${port}" hit=$((hit++)) ; elif (($? != 0 )) ; then printf ' %d' "${port}" ;  fi

        # OPTION BASED SCANS 
        elif [[ $CHOICE == 2 ]] || [[ $PORT_TYPE = "dynamic" ]] || [[ $PORT_TYPE = "registered" ]] || [[ $PORT_TYPE = "all" ]] #|| [[ $CHOICE == 2 ]] && [[ -z $LISTFLAG ]] 
        then
                echo "OPTION BASED SCAN."
                for (( port=$START;port<$END;port++))

                do
                       echo > /dev/null 2>&1 < /dev/tcp/${host}/${port}
                       if (($? == 0)) ; then printf ' %d' "${port}" hit=$((hit+1)) ; elif (($? != 0 )) ; then printf ' %d' "${port}" ;  fi
                done

        # DEFAULT COMMON PORT SCAN 
        elif [[ $PORT_TYPE = "default" ]] || [[ -z $CHOICE ]] || [[ -z $LISTFLAG ]]
        then 
                echo "DEFAULT SCAN."

                for ((port=0;port<1024;port++)) # scan common port range 0-1024
                do
                       echo > /dev/null 2>&1 < /dev/tcp/${host}/${port}
                       if (($? == 0)) ; then printf '%d' "${port}" hit=$((hit+1)) ; elif (($? != 0 )) ; then printf ' %d' "${port}" ;fi
                done
        fi


        echo ""
        if [[ $hit == 0 ]] 
        then 
                echo ""
                echo "HIT-COUNT: $hit"
                echo -e "\e[1mNO OPEN PORTS Identified. "
        else 
                echo "HIT-COUNT: $hit"
                echo # or printf '\n' 
        fi
}



# ********** 
# -- MAIN --
# **********
# 1.Check initial user input 
# 2.Perform scan based on user input  
# 3.Output Hostname and Open Port (If Any Identified)  
# 4.Store scan data in a file 

host=$1
#args=("$@") 
#printf "%s\n" "${args[@]}"



if [ -z $host ]
then
        while [ -z $host ]
        do
                echo "Please provide an ipaddress to perform the scan."
                read REPLY
                host=$REPLY
                file_check
        done

elif [ $# -eq 1 ]
then
        host=$1
        file_check # TRIGGER FLAG IF IT IS A FILE 

elif [ $# -eq 2 ]
then
        OPTION=$1
        host=$2
        file_check 

fi


HOSTNAME=$host
printf -v TODAY 'scan_%(%F)T' -1 # e.g. scan_2017-11-27
OUTFILE=${host}_${TODAY} # redirect data to an OUTFILE named <hostip/hostname>_scan_<curr.date> 



if  [[ ! -z $OPTION ]]
then
        while getopts "a:d:l:r:p" OPTION; do
        case $OPTION in

                a | "all")
                echo "Scanning all known ports."
                SPECIAL=YES
                if [ $1 == "-al" ] 
                then
                        # LIVE SCAN 
                        LIVE=YES
                fi
                START=0
                END=65536
                PORT_TYPE="all"
                ;;

                d | "dynamic")
                echo "Scanning dynamic ports."
                SPECIAL=YES
                 if [ $1 == "-dl" ]
                then
                        # LIVE SCAN
                        LIVE=YES
                fi
                START=49152
                END=65536
                PORT_TYPE="dynamic"
                ;;

                # THIS MAY NOT BE NEEDED 
                #f | "ipfile")
                #echo "Performing scan on IP HOSTLIST."
                #SPECIAL=YES
                #RUN_TYPE="ipfile"
                #TARGET="ip_file" # default will be a single ipaddr. on the cmd line
                #;;

                l | "live")
                echo "Performing a live scan."
                SPECIAL=YES # may not need this flag
                LIVE=YES # flag that indicates the user wants the info printed to screen
                PORT_TYPE="default/custom"
                port_limit="unknown"
                ;;

                p | lp | pl | "port-select")
                SPECIAL=YES
                #CUSTOM=YES
                if [ $1 == "-pl" ]
                then
                        # LIVE SCAN
                        LIVE=YES
                fi
                PORT_TYPE="custom"
                custom_port_select
                ;;

                r | rl | "registered")
                SPECIAL=YES
                PORT_TYPE="registered"
                if [ $1 == "-rl" ] || [ $1 == "-lr" ] 
                then 
                        # live implmentation of registered port scan
                        LIVE=YES
                fi
                START=1024
                END=49153
                ;;

                *)
                echo "OPTION is NOT availble."
                DEFAULT=YES
                PORT_TYPE="default"
                #port_limit=1024
                ;;
        esac
done
fi



# SCAN FILE OF IPADDR(S) 
list_scan() 
{ 
        # DISPLAY SCAN OUTPT TO SCREEN
        if ! [ -z $LIVE ] 
        then 
                while read -r line 
                do
                        scan $line

                done < $HOSTNAME | tee $OUTFILE

        # STORE SCAN OUTPUT IN FILE
        else 
                while read -r line 
                do 
                        scan $line

                done < $HOSTNAME > $OUTFILE
        fi
}


run_type() 
{ 
        if ! [ -z $LIVE ] && ! [ -z $LISTFLAG ] 
        then 
        #       file_check 
                list_scan $HOSTNAME

        elif ! [ -z $LIVE ]
        then
        #       file_check
               scan $HOSTNAME | tee $OUTFILE

        elif ! [ -z $LISTFLAG ] 
        then 
                list_scan $HOSTNAME # pass the value to the method 

        else  
                # read in user input for the port num
                 scan $HOSTNAME > $OUTFILE
        fi
}

echo "HOSTNAME: $host" 
echo "PORT: $port"
run_typecat: echo: No such file or directory

