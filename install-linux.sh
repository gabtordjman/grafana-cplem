# NXLog Installation Script for Debian
# ------------------------------------
# This script installs NXLog Community Edition on Debian systems.
# It performs the following steps:
#   1. Installs required dependencies (git, wget, curl)
#   2. Uses the NXLog .deb package stored in ./packages/
#   3. Installs NXLog with dpkg and fixes missing dependencies
#   4. Copies the configuration file (linux-nxlog.conf) to /etc/nxlog/nxlog.conf
#   5. Warns the user to check IP and PORT values in the config
#   6. Enables and starts the NXLog service, then verifies its status
# Run this script after cloning the repository.

#!/bin/bash
set -e

# Function for interactive pause
pause_step() {
    echo
    echo ">>> $1"
    read -p "Continue? (y/n): " choice
    case "$choice" in 
      y|Y ) echo "Proceeding...";;
      * ) echo "Script aborted."; exit 1;;
    esac
    echo
}

echo "=== NXLog Installation Script for Debian ==="

# Step 1: Install prerequisites
pause_step "Step 1: Update system and install prerequisites (git, wget, curl)"
apt-get update -y
apt-get install -y git wget curl

# Step 2: Use local package from repo
pause_step "Step 2: Locate NXLog package in ./packages/"
NXLOG_DEB="./packages/nxlog-ce_3.2.2329_debian11_amd64.deb"

if [ ! -f "$NXLOG_DEB" ]; then
    echo "Error: NXLog package not found at $NXLOG_DEB"
    exit 1
fi

# Verify that the file is a valid Debian package
if ! dpkg-deb --info $NXLOG_DEB > /dev/null 2>&1; then
    echo "Error: $NXLOG_DEB is not a valid Debian package."
    exit 1
fi

# Step 3: Install NXLog
pause_step "Step 3: Install NXLog using dpkg"
dpkg -i $NXLOG_DEB || true

# Step 4: Fix dependencies
pause_step "Step 4: Fix missing dependencies"
apt-get install -f -y

# Step 5: Deploy configuration
pause_step "Step 5: Copy NXLog configuration file"
CONFIG_SRC="./configs/linux-nxlog.conf"
CONFIG_DEST="/etc/nxlog/nxlog.conf"

if [ -f "$CONFIG_SRC" ]; then
    cp "$CONFIG_SRC" "$CONFIG_DEST"
    echo
    echo "###############################################"
    echo "# WARNING: Please check the IP and PORT in    #"
    echo "# $CONFIG_DEST.                               #"
    echo "# Make sure they match your environment.      #"
    echo "###############################################"
    echo
else
    echo "Config file not found at $CONFIG_SRC"
fi

# Step 6: Enable and start NXLog
echo
echo ">>> Step 6: Enable and start NXLog service"
systemctl enable nxlog
systemctl restart nxlog

# Step 7: Verify service
echo
echo ">>> Step 7: Verify NXLog service status"
systemctl status nxlog --no-pager

echo
echo "=== Installation completed successfully ==="
