#requires -module ActiveDirectory

# Paolo Frigo, https://www.scriptinglibrary.com

# This scripts creates a repot of all the Computer Objects in AD, 
# without limiting the result to a specific OU, that are not logged-in 
# since N days ago.

$NumberOfDays   =   200
$ReportName     =   "StaleObjReport.csv"

#Saves the report on the same dir of this script
$ReportNamePath = "$PSScriptRoot\\$ReportName" 
$InactivityPeriod = (Get-Date).Adddays(-($NumberOfDays))

$StaleObjectSearch = @{
    Filter = {LastLogonTimeStamp -lt $InactivityPeriod}
    Properties = "Name", "OperatingSystem", "SamAccountName", "DistinguishedName"
}

Get-ADComputer @StaleObjectSearch | Export-Csv -NoTypeInformation -Path $ReportNamePath  