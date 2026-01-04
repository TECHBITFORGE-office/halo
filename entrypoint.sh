#!/bin/bash
set -e

# --- Configuration ---
BINARY_PATH="/usr/local/bin/playit"
CONFIG_DIR="/etc/playit"
# Explicitly set the environment variable so Playit knows where to look
export PLAYIT_CONFIG_PATH="$CONFIG_DIR/playit.toml"
export RUST_LOG=info

echo "--- Starting Playit Wrapper (Debug Mode) ---"

# 1. Download Playit
if [ ! -f "$BINARY_PATH" ]; then
    echo "Binary not found. Downloading..."
    curl -L -o "$BINARY_PATH" https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64
    chmod +x "$BINARY_PATH"
fi

# 2. Check File Size (Anti-404 check)
FILE_SIZE=$(du -k "$BINARY_PATH" | cut -f1)
if [ "$FILE_SIZE" -lt 1000 ]; then
    echo "CRITICAL ERROR: Downloaded file is too small ($FILE_SIZE KB). It is likely broken."
    exit 1
fi
echo "Binary size: $FILE_SIZE KB (Looks good)"

# 3. Create Config Directory
mkdir -p "$CONFIG_DIR"

# 4. Handle Secrets
if [ ! -z "$PLAYIT_TOML" ]; then
    echo "Restoring configuration from secret..."
    echo "$PLAYIT_TOML" > "$PLAYIT_CONFIG_PATH"
else
    echo "No secret found. Generating a new Agent..."
fi

# 5. Check if binary actually runs (Version Check)
echo "Checking Playit version..."
"$BINARY_PATH" --version || echo "Warning: Could not get version"

# 6. Run Playit
echo "Launching Playit..."
echo "Please wait 10-20 seconds for the Claim URL to appear below..."
echo "-------------------------------------------------------------"

# run directly
exec "$BINARY_PATH"
