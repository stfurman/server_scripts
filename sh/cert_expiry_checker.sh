#!/bin/bash

# This script checks the expiry date of SSL certificates in a specified directory
# and sends an email alert if a certificate is expiring soon.

# Function to check the expiry date of a certificate
check_expiry() {
    local cert_file="$1"
    local days_before_expiry="$2"

    # Extract expiry date of the certificate
    expiry_date=$(openssl x509 -enddate -noout -in "$cert_file" | cut -d= -f2)

    # Convert expiry date to timestamp
    expiry_timestamp=$(date -d "$expiry_date" +%s)

    # Get current timestamp
    current_timestamp=$(date +%s)

    # Calculate days until expiry
    days_until_expiry=$(( ($expiry_timestamp - $current_timestamp) / 86400 ))

    # Check if certificate is expired or close to expiry
    if [ $days_until_expiry -lt $days_before_expiry ]; then
        alert "Certificate $cert_file is expiring in $days_until_expiry days."
    else
        echo "Certificate $cert_file is valid for at least $days_before_expiry days."
    fi
}

# Function to send email alerts
# Change the recipient email address before using this function
alert() {
    local message="$1"
    local recipient="admin@example.com"  # Change this to your email address

    # Send email alert
    echo -e "$message" | mail -s "Certificate Expiry Alert" "$recipient"
}

# Specify the directory containing certificate files
cert_dir="/etc/ssl/certs"

# Specify the number of days before expiry to trigger an alert
days_before_expiry=30

# Loop through all certificate files in the directory
for cert_file in "$cert_dir"/*.pem; do
    if [ -f "$cert_file" ]; then
        check_expiry "$cert_file" "$days_before_expiry"
    fi
done
