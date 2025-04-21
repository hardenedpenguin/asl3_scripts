#!/bin/sh
#
# Script to download and apply patch, then get public IPv4, modify link.php,
# and handle the webproxy service (systemd only).
#
# Copyright (C) 2025 Jory A. Pratt, W5GLE
#

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root." >&2
  exit 1
fi

# Define variables
patch_url="http://w5gle.us/~anarchy/tools/embedded-hamclock-to-supermon-dashboard.patch"
patch_file="/tmp/embedded-hamclock-to-supermon-dashboard.patch"
link_file="/var/www/html/supermon/link.php"
service_name="webproxy"

# Function to check if a service is running (systemd)
is_service_running() {
  systemctl is-active --quiet "$1"
}

# Function to stop and disable a service (systemd)
stop_disable_service() {
  local svc="$1"
  echo "Stopping and disabling service: $svc..."
  if systemctl is-active --quiet "$svc"; then
    if systemctl stop "$svc"; then
      echo "Successfully stopped $svc."
      if systemctl disable "$svc"; then
        echo "Successfully disabled $svc."
      else
        echo "Warning: Failed to disable $svc." >&2
      fi
    else
      echo "Error: Failed to stop $svc." >&2
    fi
  else
    echo "Service '$svc' is not running."
  fi
}

# Check for and handle webproxy
if is_service_running "$service_name"; then
  stop_disable_service "$service_name"
fi

# Download the patch to /tmp
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

# Get the public IPv4 address
echo "Getting public IPv4 address..."
public_ip=$(curl -s -4 http://ipecho.net/plain)
if [ -z "$public_ip" ]; then
  echo "Error: Failed to get public IPv4 address." >&2
  echo "Skipping IP address replacement."
  exit 1
fi

echo "Public IPv4 address: $public_ip"

# Modify link.php
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