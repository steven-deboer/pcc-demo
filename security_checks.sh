#!/bin/sh

# Initial message
echo -e "\033[1;34m
Welcome to Prisma Cloud Compute Demo
This script will simulate attacks on your system to test security measures in place
Prepare to launch sequence...
\033[0m"

# Function to handle terminal responses
terminal_response() {
    local cmd_exit_status=$1
    local attack_desc=$2
    local cmd_output=$3

    if [ $cmd_exit_status -ne 0 ]; then
        echo -e "\033[1;92m🛡️ Prisma Cloud blocked this attack: $attack_desc. 🛡️ Attack output: $cmd_output\033[0m" # Bright green for blocked attack
    else
        echo -e "\033[0;33m⚠️ I was able to execute this attack: $attack_desc. ⚠️ Attack output: $cmd_output\033[0m" # Orange for attack
    fi
}

# Function for checking /etc/passwd
check_passwd() {
    echo -e "\033[1;34m⚔️ Launching attack: Reading /etc/passwd\033[0m" # Bright blue for launching attack
    cmd_output=$(cat /etc/passwd 2>&1)
    cmd_exit_status=$?
    terminal_response $cmd_exit_status "reading /etc/passwd" "$cmd_output"
}

# Function for checking whoami
check_whoami() {
    echo -e "\033[1;34m⚔️ Launching attack: Executing whoami\033[0m" # Bright blue for launching attack
    cmd_output=$(whoami 2>&1)
    cmd_exit_status=$?
    terminal_response $cmd_exit_status "executing whoami" "$cmd_output"
}

# Function for Attack Kubernetes API
attack_kubernetes_api() {
    echo -e "\033[1;34m⚔️ Launching attack: Attacking Kubernetes API\033[0m" # Bright blue for launching attack
    cmd_output=$(curl https://kubernetes.default.svc.cluster.local 2>&1)
    cmd_exit_status=$?
    terminal_response $cmd_exit_status "Attacking Kubernetes API" "$cmd_output"
}

# Add more attack functions...

while true; do
    clear
    echo -e "\033[1;34m################ 🚀 Starting Security Checks 🚀 ################\033[0m" # Blue color for header

    # List of checks
    check_passwd
    check_whoami
    attack_kubernetes_api
    # Add other checks...

    echo -e "\033[1;34m################ 🎯 Security Checks Completed 🎯 ################\033[0m" # Blue color for footer
    echo -e "\033[1;34m💤 Sleeping for 5 seconds before the next round of checks... 💤\033[0m" # Blue color for waiting message

    sleep 5
done
