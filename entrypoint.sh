#!/bin/bash
set -e

# Define paths
BINARY_PATH="/usr/local/bin/playit"
CONFIG_DIR="/etc/playit"
CONFIG_FILE="$CONFIG_DIR/playit.toml"

echo "--- Starting Playit Wrapper for Hugging Face ---"

# 1. Download and Install Playit
# This runs the exact command you asked for if the binary is missing.
if [ ! -f "$BINARY_PATH" ]; then
    echo "Binary not found. Downloading..."
    curl -L -o /usr/local/bin/playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 \
    && chmod +x /usr/local/bin/playit
    echo "Download complete."
fi

# 2. Restore Config from Secret (Optional but recommended)
# If you have a PLAYIT_TOML secret in HF, this restores it.
if [ ! -z "$PLAYIT_TOML" ]; then
    echo "Found PLAYIT_TOML secret. Restoring configuration..."
    mkdir -p "$CONFIG_DIR"
    echo "$PLAYIT_TOML" > "$CONFIG_FILE"
fi

# 3. Run Playit
echo "Launching Playit..."
exec playit
