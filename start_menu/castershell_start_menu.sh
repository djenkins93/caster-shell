#!/bin/bash
# Description: Start menu for the "Caster-Shell" loadout
# Usage: ./caster_demp_menu

#----------------------
# STEP 1: DEFINE VARS
# ---------------------

alias ATK="cd ~/xxx./caster/atk"
DEF=~/xxx./caster/def
QUIT=$(exit 0)

#----------------------
# STEP 2: OBTAIN USER
#-----------------------
user_input()
{
        read -p "Press [Enter] to continue..." fackEnterkey
        echo "------------------------------------------------------------------------------------------------------"
}

one()
{
        user_input
        #$ATK
        cd ~/xxx./caster/atk
        #echo -e "\e[1m\e[5m\e[101mATK SELECTION:\e[25m\e[25m <user select> "
        echo -e "\e[1;5mATK SELECTION:\e[25m\e[25m "
        ls
}

two()
{
        #oecho "DEFEND!"
        #cd ~/xxx./caster/def
        user_input
        cd ~/xxx./caster/def
        ls
}

three()
{
        echo "See ya Console-Cowboy..."
        user_input
}


#-----------------
# STEP 3:
#-----------------

start_menu()
{
clear
echo -e "\e[97m


               .#       .
          .  ####*###### .       .
        .  ################,         . . .
      .   ######&.    %####% %##%  #%   .
      .  #####(          #### ,#####  .
      .  #####            ###% ###   .  ====================================================================
      .  #% #             #### ##*
        %# %*   #%%##%    ###  ##%         ::::::::      :::      :::::::: ::::::::::: :::::::::: :::::::::
      .   .     %#%%###&/##. #,           :+:    :+:   :+: :+:   :+:    :+:    :+:     :+:        :+:    :+:
              %###,#% % ###  %&(         +:+         +:+   +:+  +:+           +:+     +:+        +:+    +:+
               (%     ####   ...        +#+        +#++:++#++: +#++:++#++    +#+     +#++:++#   +#++:++#:
               ,   *####   .           +#+        +#+     +#+        +#+    +#+     +#+        +#+    +#+
             .   %###%   .            #+#    #+# #+#     #+# #+#    #+#    #+#     #+#        #+#    #+#
              #####%                  ########  ###     ###  ########     ###     ########## ###    ###
        .  %####.     .      .
          %##%   .  .   %%   .                     ::::::::  :::    ::: :::::::::: :::        :::
    (%%*,##%,  .     .%#%.%##                    :+:    :+: :+:    :+: :+:        :+:        :+:
    (% #%##&            (.  *%%.   .            +:+        +:+    +:+ +:+        +:+        +:+
     & %%%%(     .  %%%%      %%%   .          +#++:++#++ +#++:++#++ +#++:++#   +#+        +#+
    %%,#%%%%                %# %&    .               +#+ +#+    +#+ +#+        +#+        +#+
       (%%%%#              %% %%%   .       #+#    #+# #+#    #+# #+#        #+#        #+#
     .  %%%%%/         .%%%..%%%   .        ########  ###    ### ########## ########## ##########
      .  &%%%%%%%%%%%%%%%%%%%%%   .
          %%%%%%%%%%%%%%%%%&   .     ======================================================================
        .     &%%%%%%%&    . .    Coded by SomeKidFromKansas [ DEMO ONLY | RELEASE DATE: 2021 ]
"


        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "START MENU: Welcome Outlaw, Please make a selection. (Press '-e' for Exented view)"
        echo "[1.]--ATK"
        echo "[2.]--DEF"
        echo "[3.]--more info"
        echo "[4.]--QUIT"
        echo "------------------------------------------------------------------------------------------------------"
        #echo -e "\e[1m\e[5mSELECT:\e[25m\e[25m <user select> "
}

read_select()
{
        local select
        read -p "Enter selection :" select
        #read -p " \e[1m\e[5mSELECT:\e[25m\e[25m " select
        case $select in
                1) one ;;
                2) two ;;
                3) three;;
                *) echo -e "${RED}ERROR...${STD}" && sleep 2 ;;
        esac
}

start_menu
read_select

        