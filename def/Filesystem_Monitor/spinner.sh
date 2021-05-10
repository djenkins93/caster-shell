#!/bin/bash
# 
# Desription: use this code for a loading/running program animation 
# Usage: "./spinner.sh" --run while program is running 
# MODs/Bugs: 1. Modify the script so that the loading 'animation/char' is erased once the script is finished 
# 2. Modify the sc
# 3. Display the message "Task Complete." once the spinner is done running 


spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

printf 'Running Task...'
spinner &

sleep 30 # sleeping for 10 seconds is important work

printf '\n'
kill "$!" # kill the spinner
echo -e '\e[1A\e[KTask Complete.'
#printf '\n'chronos@localhost ~/xxx./caster/def/Filesystem_monitor $ cat spinner.sh  && echo
#!/bin/bash
# 
# Desription: use this code for a loading/running program animation 
# Usage: "./spinner.sh" --run while program is running 
# MODs/Bugs: 1. Modify the script so that the loading 'animation/char' is erased once the script is finished 
# 2. Modify the sc
# 3. Display the message "Task Complete." once the spinner is done running 


spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

printf 'Running Task...'
spinner &

sleep 30 # sleeping for 10 seconds is important work

printf '\n'
kill "$!" # kill the spinner
echo -e '\e[1A\e[KTask Complete.'
#printf '\n'