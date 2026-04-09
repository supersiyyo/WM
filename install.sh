#!/bin/bash

# Configuration and deployment script for WM project

echo "============================================="
echo "  Deploying WM Environment Configuration     "
echo "============================================="

# Ensure running from the repository root
if [ ! -d "./autostart" ] || [ ! -d "./nginx" ] || [ ! -d "./scripts" ]; then
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

echo ""
echo "3. Setting up Nginx Configuration (Requires sudo)..."
if [ -f "./nginx/nginx.config" ]; then
    sudo cp "./nginx/nginx.config" "/etc/nginx/"
    echo "  -> Copied nginx.config to /etc/nginx/"
    echo "  -> Testing Nginx configuration..."
    sudo nginx -t
    if [ $? -eq 0 ]; then
        echo "  -> Restarting Nginx service..."
        sudo systemctl restart nginx
    else
        echo "  -> Nginx configuration test failed. Please check your syntax."
    fi
fi

echo "============================================="
echo "  Deployment Complete!                       "
echo "============================================="
