#!/bin/bash
# Paolo Frigo, https://www.scriptinglibrary.com
#THIS SCRIPT RETURNS THE TOP N IP IN THE IIS LOGS FOLDER 
TOP=10   

function find_top_ip () {
    IISLOG=$1
    echo "This is the TOP $TOP for the $IISLOG log file"
    echo "--------------------------------------"
    echo "   HIT | IP"
    echo "--------------------------------------"
    cat $IISLOG | cut -d ' ' -f 9 | sort | uniq -c | sort -r | head -n $TOP 
    echo "--------------------------------------"
}

for f in *.log; do find_top_ip $f; done