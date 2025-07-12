#!/bin/bash

set -e

SERVICE_NAME="pipause"
INSTALL_DIR="/opt/$SERVICE_NAME"
VENV_DIR="$INSTALL_DIR/venv"
SERVICE_FILE="$SERVICE_NAME.service"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Prompt for API key
read -sp "Enter your Pi-hole API key (app password): " API_KEY
echo

# Create install directory and copy code
echo "📁 Installing to $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo cp "$SCRIPT_DIR/"*.py "$INSTALL_DIR/"
sudo chmod +x "$INSTALL_DIR/main.py"

# Create .env file with API key
echo "PIHOLE_API_KEY=\"$API_KEY\"" | sudo tee "$INSTALL_DIR/.env" > /dev/null

# Install virtualenv and create venv
echo "🐍 Setting up Python virtual environment..."
sudo apt-get update
sudo apt-get install -y python3-venv
sudo python3 -m venv "$VENV_DIR"
sudo "$VENV_DIR/bin/pip" install --upgrade pip
sudo "$VENV_DIR/bin/pip" install gpiozero requests

# Copy systemd service file
echo "🛠️  Configuring systemd..."
sudo cp "$SCRIPT_DIR/$SERVICE_FILE" "/etc/systemd/system/$SERVICE_FILE"
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_FILE"
sudo systemctl restart "$SERVICE_FILE"

echo "✅ Install complete. Service is running as $SERVICE_NAME."
