#!/bin/bash
set -e

# NXLog Installation Script for Debian
# ------------------------------------
# This script installs NXLog Community Edition on Debian systems.
# It performs the following steps:
#   1. Installs required dependencies (git, wget, curl)
#   2. Clones the Grafana CPL&EM repository
#   3. Uses the NXLog .deb package stored in ./packages/
#   4. Installs NXLog with dpkg and fixes missing dependencies
#   5. Copies the configuration file (linux-nxlog.conf) to /etc/nxlog/nxlog.conf
#   6. Warns the user to check IP/PORT values in the config
#   7. Enables and starts the NXLog service, then verifies its status

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

# Step 2: Clone repository
pause_step "Step 2: Clone the Grafana CPL&EM repository"
REPO_URL="https://github.com/gabtordjman/grafana-cplem.git"
REPO_DIR="grafana-cplem"

if [ -d "$REPO_DIR" ]; then
    echo "Repository already exists. Skipping clone."
else
    git clone $REPO_URL
fi

cd $REPO_DIR

# Step 3: Use local NXLog package
pause_step "Step 3: Locate NXLog package in ./packages/"
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

# Step 4: Install NXLog
pause_step "Step 4: Install NXLog using dpkg"
dpkg -i $NXLOG_DEB || true

# Step 5: Fix dependencies
pause_step "Step 5: Fix missing dependencies"
apt-get install -f -y

# Step 6: Deploy configuration
pause_step "Step 6: Copy NXLog configuration file"
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

# Step 7: Enable and start NXLog
echo
echo ">>> Step 7: Enable and start NXLog service"
systemctl enable nxlog
systemctl restart nxlog

# Step 8: Verify service
echo
echo ">>> Step 8: Verify NXLog service status"
systemctl status nxlog --no-pager

echo
echo "=== Installation completed successfully ==="
