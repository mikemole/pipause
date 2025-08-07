#!/bin/bash
set -e

SERVICE_NAME="pipause"
INSTALL_DIR="/opt/$SERVICE_NAME"
SERVICE_FILE="$SERVICE_NAME.service"

echo "🛑 Stopping and disabling $SERVICE_NAME..."
sudo systemctl stop "$SERVICE_NAME" || true
sudo systemctl disable "$SERVICE_NAME" || true

echo "🗑️ Removing systemd service..."
sudo rm -f "/etc/systemd/system/$SERVICE_FILE"
sudo systemctl daemon-reload

echo "🗑️ Removing installation directory..."
sudo rm -rf "$INSTALL_DIR"

# Optionally remove installed Python packages (if they were only for this project)
#read -p "Remove gpiozero and requests from system Python? [y/N] " REPLY
#if [[ "$REPLY" =~ ^[Yy]$ ]]; then
#    sudo pip3 uninstall -y gpiozero requests RPi.GPIO
#fi

# Remove the 'pi' user if it was created by the installer
if id "pi" >/dev/null 2>&1; then
    read -p "Remove 'pi' user? [y/N] " REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        sudo deluser pi
    fi
fi

echo "✅ Uninstall complete."
