​#!/bin/bash

#  
# This scripts uses and requires NMAP, creates a report with all host connected to the SUBNET
#
# author: paolofrigo@gmail.com , https://www.scriptinglibrary.com 

# CONFIGURE ACCORDING TO YOUR NEEDS
REPORT_FILENAME="scan-$(date +%Y-%m-%d).txt"
WIFI_SUBNET="192.168.0" 

nmap -sL $WIFI_SUBNET.* | grep -v "^Nmap scan report for $WIFI_SUBNET" | replace "Nmap scan report for " ""| tee $REPORT_FILENAME
echo "--- $REPORT_FILENAME has been created! ---"
​