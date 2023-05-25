#!/bin/sh

# Function for response based on command execution status
terminal_response() {
    if [ "$1" -eq 0 ]; then
        echo -e "\033[38;5;202m⚠️  I was able to execute this attack: $2 ⚠️\033[0m"
        if [ "$4" -eq 1 ]; then
            echo -e "\033[38;5;202mAttack output: \n$3\033[0m"
        fi
    else
        echo -e "\033[38;5;34m✅  Prisma Cloud blocked this attack: $2 ✅\033[0m"
    fi
    echo -e "\n---------------------------------------------------------\n"
}

# Function to check /etc/passwd
check_passwd() {
    cmd_output=$(cat /etc/passwd 2>&1)
    cmd_exit_status=$?
    terminal_response $cmd_exit_status "reading /etc/passwd" "$cmd_output" "$1"
}

# Function to check whoami
check_whoami() {
    cmd_output=$(whoami 2>&1)
    cmd_exit_status=$?
    terminal_response $cmd_exit_status "executing whoami" "$cmd_output" "$1"
}

# Function to download malware
download_malware() {
    cmd_output=$(wget http://wildfire.paloaltonetworks.com/publicapi/test/elf -O /tmp/malware-sample 2>&1)
    cmd_exit_status=$?
    terminal_response $cmd_exit_status "downloading malware" "$cmd_output" "$1"
}

# Check if verbose mode is enabled
if [ "$1" == "-v" ]; then
    verbose_mode=1
else
    verbose_mode=0
fi

while true; do
    printf "\033c"
    echo -e "\033[1;34m
    ╔════════════════════════════════════════════════════════════════════╗
    ║                                                                    ║
    ║       🚀   Welcome to the Security Checks tool   🚀                ║
    ║                                                                    ║
    ║   Please press any key to initiate the security checks. These      ║
    ║   checks are designed to simulate potential security attacks and   ║
    ║   to validate the effectiveness of our security measures.          ║
    ║                                                                    ║
    ║   Press 'q' to quit the application.                               ║
    ║                                                                    ║
    ╚════════════════════════════════════════════════════════════════════╝
    \033[0m"
    read -s -n 1 key
    if [[ "$key" == "q" ]]; then
        break
    fi
    sleep 1
    check_passwd $verbose_mode
    sleep 1
    check_whoami $verbose_mode
    sleep 1
    download_malware $verbose_mode
    sleep 1
    echo -e "\n\033[1;34mPress any key to restart the Security Checks, or 'q' to quit\033[0m"
    read -s -n 1 key
    if [[ "$key" == "q" ]]; then
        break
    fi
done
