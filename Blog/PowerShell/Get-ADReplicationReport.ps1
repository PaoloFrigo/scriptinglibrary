#requires -module ActiveDirectory

# Paolo Frigo, https://www.scriptinglibrary.com

# Generates a Report for the AD replication status and AD DC Diagnosis

$DATE = get-date -Format "yyyy-MM-dd"
$REPORT_PATH = "ADSyncReport-$DATE.txt"

<#

Write-Output "Summarize the replication status and view overall health"
repadmin /replsummary > $REPORT_PATH

Write-Output "Show replication partner and status"
repadmin /showrepl >> $REPORT_PATH

Write-Output "Show only Replication Errors"
repadmin /showrepl /errorsonly >> $REPORT_PATH

Write-Output "Show replication Queue"
Repadmin /Queue >> $REPORT_PATH

Write-Output "How to Force Active Directory Replication"
repadmin /syncall >> $REPORT_PATH
repadmin /syncall /aed >> $REPORT_PATH

Write-Output "Find the last time your DC were backup"
Repadmin /showbackup * >> $REPORT_PATH

Write-Output "Displays calls that have not yet been answered"
repadmin /showoutcalls * >> $REPORT_PATH

Write-Output "List the Topology information"
repadmin /bridgeheads * /verbose >> $REPORT_PATH

Write-Output "Inter Site Topology Generator Report"
repadmin /istg * /verbose >> $REPORT_PATH
#>

<#

REPADMIN /KCC > $REPORT_PATH
REPADMIN /REHOST >> $REPORT_PATH
REPADMIN /REPLICATE >> $REPORT_PATH
#>

REPADMIN /REPLSUM >> $REPORT_PATH
REPADMIN /SHOWREPL >> $REPORT_PATH
REPADMIN /SHOWREPS >> $REPORT_PATH
REPADMIN /SHOWUTDVEC >> $REPORT_PATH
REPADMIN /SYNCALL >> $REPORT_PATH

foreach ($DC in (Get-ADDomain).ReplicaDirectoryServers){
    dcdiag /s:$DC /v >> $REPORT_PATH
}

Write-Output "Report generated: $REPORT_PATH"

<#
Write-Output "Sending the generated report via email to the ops team."
Send-MailMessage -From "SENDER" `
                 -to "RECIPIENT" `
                 -Attachments $REPORT_PATH `
                 -Subject "AD replication and ADDC Diagnosis report" `
                 -Body "Please review the report attached" `
                 -smtp "MAILSERVER"
#>