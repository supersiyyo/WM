#!/bin/bash

# Configuration and deployment script for WM project

echo "============================================="
echo "  Deploying WM Environment Configuration     "
echo "============================================="

# Ensure running from the repository root
if [ ! -d "./autostart" ] || [ ! -d "./scripts" ]; then
    echo "Error: Please run this script from the root of the WM repository."
    exit 1
fi

echo "1. Setting up Autostart Desktop Entries..."
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

# Copy all desktop files (excluding placeholders) to the autostart directory
for file in ./autostart/*.desktop; do
    if [ -f "$file" ]; then
        cp "$file" "$AUTOSTART_DIR/"
        echo "  -> Copied $(basename "$file") to $AUTOSTART_DIR/"
    fi
done

echo ""
echo "2. Setting up Scripts..."
SCRIPTS_DIR="$HOME/scripts"
mkdir -p "$SCRIPTS_DIR"

if [ -f "./scripts/start_vnc_scraper.sh" ]; then
    cp "./scripts/start_vnc_scraper.sh" "$SCRIPTS_DIR/"
    chmod +x "$SCRIPTS_DIR/start_vnc_scraper.sh"
    echo "  -> Copied start_vnc_scraper.sh to $SCRIPTS_DIR/ and made it executable"
fi

if [ -f "./scripts/start_camera_stream.sh" ]; then
    cp "./scripts/start_camera_stream.sh" "$SCRIPTS_DIR/"
    chmod +x "$SCRIPTS_DIR/start_camera_stream.sh"
    echo "  -> Copied start_camera_stream.sh to $SCRIPTS_DIR/ and made it executable"
fi

echo ""
echo "3. Setting up MediaMTX Configuration (Requires sudo)..."
echo "  -> Downloading MediaMTX v1.9.3..."
wget -q -O /tmp/mediamtx.tar.gz https://github.com/bluenviron/mediamtx/releases/download/v1.9.3/mediamtx_v1.9.3_linux_arm64v8.tar.gz
if [ $? -eq 0 ]; then
    sudo mkdir -p /opt/mediamtx
    sudo tar -xzf /tmp/mediamtx.tar.gz -C /opt/mediamtx
    rm /tmp/mediamtx.tar.gz
    
    echo "  -> Creating systemd service for MediaMTX..."
    cat << 'EOF' | sudo tee /etc/systemd/system/mediamtx.service > /dev/null
[Unit]
Description=MediaMTX Server
After=network.target

[Service]
ExecStart=/opt/mediamtx/mediamtx /opt/mediamtx/mediamtx.yml
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
    sudo systemctl enable mediamtx
    sudo systemctl restart mediamtx
    
    # Optional: If Nginx was previously installed, try removing/disabling it
    sudo systemctl stop nginx 2>/dev/null
    sudo systemctl disable nginx 2>/dev/null
    
    echo "  -> MediaMTX installed and started!"
else
    echo "  -> Failed to download MediaMTX. Please check your internet connection."
fi

echo "============================================="
echo "  Deployment Complete!                       "
echo "============================================="
