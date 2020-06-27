​#!/bin/bash

#  
# This scripts uses and requires NMAP, creates a report with all hosts connected to the SUBNET
#
# author: Paolo Frigo https://www.scriptinglibrary.com 

# CONFIGURE ACCORDING TO YOUR NEEDS
REPORT_FILENAME="scan-$(date +%Y-%m-%d).txt"
WIFI_SUBNET="10.0.0" 

nmap -sL $WIFI_SUBNET.* | grep -v "^Nmap scan report for $WIFI_SUBNET" | sed -e 's/Nmap scan report for //g'| tee $REPORT_FILENAME
echo "--- $REPORT_FILENAME has been created! ---"
​
