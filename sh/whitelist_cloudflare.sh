#!/bin/bash

# This script allows you to whitelist Cloudflare IP ranges in UFW (Uncomplicated Firewall).
# It also allows you to whitelist your own IP address for SSH access. 
# IMPORTANT: Make sure to replace MY_IP with your own IP address before running the script.
# You can also uncomment the line that allows SSH traffic if you want to allow SSH access.

# Define my IP address
MY_IP="127.0.0.1" # replace with your IP address

# Download and define Cloudflare IPv4 ranges
CLOUDFLARE_IPv4_URL="https://www.cloudflare.com/ips-v4"
CLOUDFLARE_IPv4_FILE="/tmp/cloudflare_ips_v4"

# Download and define Cloudflare IPv6 ranges
CLOUDFLARE_IPv6_URL="https://www.cloudflare.com/ips-v6"
CLOUDFLARE_IPv6_FILE="/tmp/cloudflare_ips_v6"

# Retrieve Cloudflare IPv4 ranges and store them in a temporary file
curl -s "$CLOUDFLARE_IPv4_URL" > "$CLOUDFLARE_IPv4_FILE"

# Retrieve Cloudflare IPv6 ranges and store them in a temporary file
curl -s "$CLOUDFLARE_IPv6_URL" > "$CLOUDFLARE_IPv6_FILE"

# Flush existing ufw rules
ufw --force reset

# Deny all incoming traffic by default
ufw default deny incoming

# Allow outgoing traffic by default
sudo ufw default allow outgoing

# Allow custom IP
ufw allow from "$MY_IP" comment 'My IP address'

# Allow SSH
# ufw allow ssh comment 'Allow SSH' # uncomment if you want to allow SSH

# Allow traffic from Cloudflare IP ranges (IPv4)
while IFS= read -r ip_range; do
    ufw allow from "$ip_range" to any port 80,443 proto tcp comment 'Cloudflare';
done < "$CLOUDFLARE_IPv4_FILE"

# Allow traffic from Cloudflare IP ranges (IPv6)
while IFS= read -r ip_range; do
    ufw allow from "$ip_range" to any port 80,443 proto tcp comment 'Cloudflare';
done < "$CLOUDFLARE_IPv6_FILE"

# Enable ufw
ufw --force enable

# Cleanup: Remove temporary files
rm -f "$CLOUDFLARE_IPv4_FILE" "$CLOUDFLARE_IPv6_FILE"

ufw status verbose
