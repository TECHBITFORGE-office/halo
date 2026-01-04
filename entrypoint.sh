#!/bin/bash
set -e

# Define paths
BINARY_PATH="/usr/local/bin/playit"
CONFIG_DIR="/etc/playit"
CONFIG_FILE="$CONFIG_DIR/playit.toml"

echo "--- Starting Playit Wrapper for Hugging Face ---"

# 1. Download and Install Playit
if [ ! -f "$BINARY_PATH" ]; then
    echo "Binary not found. Downloading..."
    # Use the official direct download link (more reliable)
    curl -L -o "$BINARY_PATH" https://playit.gg/downloads/playit-linux-amd64
    chmod +x "$BINARY_PATH"
    echo "Download complete."
fi

# 2. ALWAYS create the config directory
# This was the missing step causing the crash
mkdir -p "$CONFIG_DIR"

# 3. Restore Config from Secret (Optional)
if [ ! -z "$PLAYIT_TOML" ]; then
    echo "Found PLAYIT_TOML secret. Restoring configuration..."
    echo "$PLAYIT_TOML" > "$CONFIG_FILE"
else
    echo "No secret found. Playit will generate a new Claim URL."
fi

# 4. Run Playit
echo "Launching Playit..."
# usage of the specific path ensures we run what we downloaded
exec "$BINARY_PATH"
