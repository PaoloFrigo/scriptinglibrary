#!/bin/bash

#Paolo Frigo, https://www.scriptinglibrary.com

# SETTINGS
NETWORK="" #123.3.2.1/24
API_KEY="" #use you api key from abuseipdb.com
DAYS=7

if [[ $NETWORK == "" ||  $API_KEY == "" ]]; then
        echo "Please edit your NETWORK and API Settings";
        exit 1
fi
# NOTES
# If you want use this script as a custom Nagios Check copy it on 
# /usr/local/nagios/libexec/ and use the exit values that are commented out below

AbuseIPCheck=$(curl -s -G https://api.abuseipdb.com/api/v2/check-block \
        --data-urlencode "network=$NETWORK" \
        -d maxAgeInDays=$DAYS \
        -H "Key: $API_KEY" \
        -H "Accept: application/json" |jq '.data.reportedAddress')

if [ "$AbuseIPCheck" != [] ]; then
        echo "CRITICAL: $AbuseIPCheck";
        #exit 2 #Comment out for Nagios 
else
        echo "OK";
        #exit 0 #Comment out for Nagios
fi
