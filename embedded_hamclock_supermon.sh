#!/bin/sh
#
# Script to download and apply patch, then get public IP and modify link.php
#

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root." >&2
  exit 1
fi

# Download the patch to /tmp
patch_url="http://w5gle.us/~anarchy/tools/embedded-hamclock-to-supermon-dashboard.patch"
patch_file="/tmp/embedded-hamclock-to-supermon-dashboard.patch"

echo "Downloading patch..."
if ! curl -sLo "$patch_file" "$patch_url"; then
  echo "Error: Failed to download patch." >&2
  exit 1
fi

# Change directory to /
echo "Changing directory to /..."
cd / || {
  echo "Error: Failed to change directory to /." >&2
  exit 1
}

# Apply the patch
echo "Applying patch..."
if ! patch -p1 < "$patch_file"; then
  echo "Error: Failed to apply patch.  Exiting, but attempting IP replacement." >&2
fi

# Get the public IP address
echo "Getting public IP address..."
public_ip=$(curl -s http://ipecho.net/plain)
if [ -z "$public_ip" ]; then
  echo "Error: Failed to get public IP address." >&2
  echo "Skipping IP address replacement."
  exit 1
fi

echo "Public IP address: $public_ip"

# Modify link.php
link_file="/var/www/html/link.php" # Adjust this path if necessary
echo "Modifying $link_file..."
if [ -f "$link_file" ]; then
  if ! sed -i "s/yourpublicip/$public_ip/g" "$link_file"; then
    echo "Error: Failed to replace 'yourpublicip' in $link_file." >&2
    exit 1
  fi
  echo "Successfully replaced 'yourpublicip' with '$public_ip' in $link_file."
else
  echo "Warning: $link_file not found.  Skipping IP address replacement." >&2
  exit 1
fi

echo "Script completed."
echo "
Important:
- Ensure that port 8082 is forwarded to your Hamclock device's IP address.
- If a firewall is running on your Hamclock device, you will need to open port 8082."
exit 0
