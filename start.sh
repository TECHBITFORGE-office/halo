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

# Add the user to sudo group so you can use 'sudo' commands
usermod -aG sudo "$SSH_USER"
#2. START SERVICES
# Start the Fake Flask API in the background
echo "Starting Flask APΙ..."
python3 /app/app.py &
# Start the SSH Server
echo "Starting SSH Server..."
service ssh start
# Start the Cloudflare Tunnel
if [ -z "$CF_TOKEN" ]; then
echo "Error: CF_TOKEN secret is missing!"
exit 1
fi
echo "Starting Cloudflare Tunnel..."
cloudflared tunnel run --token "$CF_TOKEN"
