#!/bin/sh
#
# Description: This script downloads and applies a patch, edits an INI file,
#              and adds a crontab entry. It requires root privileges to run.
#
# Copyright (c) 2025 Jory A. Pratt, W5GLE
#
# Patch URL: http://w5gle.us/~anarchy/tools/supermon-mode-variables-v2.patch

# Define variables
PATCH_URL="http://w5gle.us/~anarchy/tools/supermon-mode-variables-v2.patch"
INI_FILE="/usr/local/sbin/node_info.ini"
CRONTAB_ENTRY="*/3 * * * * /usr/local/sbin/ast_node_status_update.py # Update variables every 3 minutes for supermon"
PATCH_FILE="supermon.patch"
PATCH_DIR="/tmp" # Added variable for patch download directory

# Function to download the patch
download_patch() {
    echo "Downloading patch from $PATCH_URL to $PATCH_DIR..."
    if ! curl -sLo "$PATCH_DIR/$PATCH_FILE" "$PATCH_URL"; then
        echo "Failed to download the patch."
        exit 1
    fi
    echo "Patch downloaded successfully to $PATCH_DIR/$PATCH_FILE."
}

# Function to apply the patch
apply_patch() {
    echo "Applying patch from $PATCH_DIR/$PATCH_FILE..."
    cd /
    if [ $? -ne 0 ]; then
        echo "Failed to change directory to /."
        exit 1
    fi
    if ! patch -p1 < "$PATCH_DIR/$PATCH_FILE"; then
        echo "Failed to apply the patch."
        exit 1
    fi
    echo "Patch applied successfully."
}

# Function to edit the INI file with nano
edit_ini_file_with_nano() {
    echo "Opening INI file with nano: $INI_FILE"
    nano "$INI_FILE"
    if [ $? -ne 0 ]; then
        echo "Failed to open $INI_FILE with nano."
        exit 1
    fi
    echo "INI file edited."
}


# Function to add the crontab entry
add_crontab_entry() {
    echo "Adding crontab entry..."
    if crontab -l | grep -q "$CRONTAB_ENTRY"; then
        echo "Crontab entry already exists."
    else
        (crontab -l; echo "$CRONTAB_ENTRY") | crontab
        if [ $? -ne 0 ]; then
            echo "Failed to add crontab entry."
            exit 1
        fi
        echo "Crontab entry added."
    fi
}

# Function to clean up the downloaded patch file
cleanup_patch() {
    echo "Cleaning up patch file..."
    rm -f "$PATCH_DIR/$PATCH_FILE"
    if [ $? -ne 0 ]; then
        echo "Failed to remove patch file: $PATCH_FILE"
    fi
    echo "Patch file cleaned up."
}

# Main script logic
download_patch
apply_patch
edit_ini_file_with_nano # Changed to use nano
add_crontab_entry
cleanup_patch

echo "Script completed."
exit 0
