#!/bin/bash

# --- 1. USER SETUP ---
# Create the user from the 'SSH_USER' secret
if [ -z "$SSH_USER" ]; then
    echo "Error: SSH_USER secret is missing!"
    exit 1
fi
useradd -m -s /bin/bash "$SSH_USER"

# Set the password from the 'SSH_PASS' secret
if [ -z "$SSH_PASS" ]; then
    echo "Error: SSH_PASS secret is missing!"
    exit 1
fi
echo "$SSH_USER:$SSH_PASS" | chpasswd
