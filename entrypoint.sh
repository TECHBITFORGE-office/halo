#!/bin/bash
set -e

# Define paths
BINARY_PATH="/usr/local/bin/playit"
CONFIG_DIR="/etc/playit"
CONFIG_FILE="$CONFIG_DIR/playit.toml"

echo "--- Starting Playit Wrapper for Hugging Face ---"

# 1. Download and Install Playit
# We use the GitHub releases link which is reliable
if [ ! -f "$BINARY_PATH" ]; then
    echo "Binary not found. Downloading..."
    curl -L -o "$BINARY_PATH" https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64
    chmod +x "$BINARY_PATH"
fi

# 2. Verify the download worked
# If the file is too small (under 1MB), it's probably an error page, so we stop.
FILE_SIZE=$(du -k "$BINARY_PATH" | cut -f1)
if [ "$FILE_SIZE" -lt 1000 ]; then
    echo "Error: The downloaded file is too small ($FILE_SIZE KB). It is likely a broken link or error page."
    exit 1
fi
echo "Download successful ($FILE_SIZE KB)."

# 3. Create config directory (Critical step!)
mkdir -p "$CONFIG_DIR"

# 4. Restore Config from Secret (Optional)
if [ ! -z "$PLAYIT_TOML" ]; then
    echo "Found PLAYIT_TOML secret. Restoring configuration..."
    echo "$PLAYIT_TOML" > "$CONFIG_FILE"
else
    echo "No secret found. A new Claim URL will be generated in the logs."
fi

# 5. Run Playit
echo "Launching Playit..."
exec "$BINARY_PATH"
