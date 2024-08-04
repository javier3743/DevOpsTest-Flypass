#!/bin/bash
# log_ip.sh - Script to log the IP address

# Get the current IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Get the current timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Write the IP address and timestamp to a file
echo "$TIMESTAMP - $IP_ADDRESS" >> /var/log/ip_address.log
