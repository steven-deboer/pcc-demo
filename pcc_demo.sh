#!/bin/sh

# Function for response based on command execution status
terminal_response() {
    echo -ne "\n"
    if [ "$1" -eq 0 ]; then
        echo -e "\033[38;5;202m⚠️  I was able to execute this attack: $2. ⚠️\033[0m"
        if [ "$4" -eq 1 ]; then
            echo -e "\033[38;5;202mAttack output: \n$3\033[0m"
        fi
    else
        echo -e "\033[38;5;34m✅  Prisma Cloud blocked this attack: $2. ✅\033[0m"
    fi
    sleep 2
}

# Function to check /etc/passwd
check_passwd() {
    echo -e "\n\033[1;34m⚔️  Launching attack: Reading /etc/passwd\033[0m"
    sleep 1
    cmd_output=$(cat /etc/passwd 2>&1)
    cmd_exit_status=$?
    terminal_response $cmd_exit_status "reading /etc/passwd" "$cmd_output" "$1"
}

# Function to check whoami
check_whoami() {
    echo -e "\n\033[1;34m⚔️  Launching attack: Executing whoami\033[0m"
    sleep 1
    cmd_output=$(whoami 2>&1)
    cmd_exit_status=$?
    terminal_response $cmd_exit_status "executing whoami" "$cmd_output" "$1"
}

# Check if verbose mode is enabled
if [ "$1" == "-v" ]; then
    verbose_mode=1
else
    verbose_mode=0
fi

while true; do
    printf "\033c"

    # Top box line
    echo -e "\033[1;34m
    ╔════════════════════════════════════════════════════════════════════╗
    ║      🚀   Starting Security Checks   🚀                            ║
    ╚════════════════════════════════════════════════════════════════════╝
    \033[0m"

    check_passwd $verbose_mode
    check_whoami $verbose_mode

    # Progress bar
    for i in $(seq 20 -1 1)
    do
        printf "\r["
        for j in $(seq $i); do printf "#"; done
        for j in $(seq $((80-i))); do printf " "; done
        printf "] \033[1;32m$i\033[0m"
        sleep 1
    done
    printf "\033[2K"
done
