#!/bin/bash

set -e

SERVICE_NAME="pipause"
INSTALL_DIR="/opt/$SERVICE_NAME"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

echo "⚠️  This will stop and remove the $SERVICE_NAME service and delete files from:"
echo "   - $INSTALL_DIR"
echo "   - $SERVICE_FILE"
read -p "Are you sure you want to uninstall? [y/N] " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "❌ Uninstall cancelled."
    exit 1
fi

# Stop and disable the systemd service
echo "🛑 Stopping and disabling $SERVICE_NAME..."
sudo systemctl stop "$SERVICE_NAME.service" || true
sudo systemctl disable "$SERVICE_NAME.service" || true
sudo systemctl daemon-reload

# Remove systemd service file
if [ -f "$SERVICE_FILE" ]; then
    echo "🧹 Removing systemd unit file..."
    sudo rm "$SERVICE_FILE"
fi

# Remove install directory
if [ -d "$INSTALL_DIR" ]; then
    echo "🧽 Deleting installed files in $INSTALL_DIR..."
    sudo rm -rf "$INSTALL_DIR"
fi

echo "✅ Uninstall complete."
