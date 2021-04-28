#requires -module ActiveDirectory

<#
PF, https://www.scriptinglibrary.com

.SYNOPSIS
This script inspect the most recent log file and prints a list of internal and external ip with usernames

.DESCRIPTION
This script inspect the most recent log file and prints a list of internal and external ip with usernames

.EXAMPLE
.\Inspect-IISLogs.ps1

.EXAMPLE
Run an infinite loop in a separate powershell window and update every 1minute

while($true){clear; .\Inspect-IISLogs.ps1 ; (get-date).datetime ; sleep -Seconds 60;}
#>

#SETTINGS
$LogFolder="D:\Logs\W3SVC1"
$MostRecentLogFile = (Get-ChildItem $LogFolder)[-1].FullName
$allLines= Get-Content $MostRecentLogFile
$IPStats=@{}
$PrivateNtwk="10.0"

Function Parse-LogEntry{
    [CmdletBinding()]    
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $line
    )

    if ($line){
        $fields=$line.Split(" ")
        $user=$fields[7]
        $ip=$fields[8]
        #$browser=$fields[9]
        #$date=$fields[0]
        #$time=$fields[1]
        #$code=$fields[11]
        if (($ip -notmatch "::1") -and ($ip -notmatch "127.0.0.1" ) ){
            return "$ip", "$user" #, $code,  $browser, $date, $time
        }
    }
}
Function Generate-Stats{
[CmdletBinding()]
param (
        [Parameter(Mandatory=$true)]
        [string]
        $ip,
        [Parameter(Mandatory=$true)]
        [string]
        $user
    )

    if ($user -like "-" -or $ip -like "cs-username")
    {
        return
    }
    #Convert user SID with fullname, upn or samaaccount
    if ($user -match "S-1-5"){
        $user = get-aduser -filter{sid -like $user} |Select-Object -exp name #userpricipalname #samaccountname
    }
    if ($IPStats["$ip"]){
        if ([array]$IPStats["$ip"] -notcontains $user ){
            $IPStats["$ip"] = $IPStats["$ip"] , "$user"
        }
        else {
            return
        }
    }
    else{
        $IPStats["$ip"] =  $user
    }
}
Foreach ($Line in $AllLines){
    $parsedline = Parse-LogEntry($line)
    if ($parsedline){
        Generate-Stats -ip $parsedline[0] -user $parsedline[1]
    }
}

Write-Output "`nINTERNAL IPs`n------------------------"
$IPStats.GetEnumerator() | Where-Object {$_.name -match "$PrivateNtwk"} | sort-object -Property name
Write-Output "`nEXTERNAL IPs`n------------------------"
$IPStats.GetEnumerator() | Where-Object {$_.name -notmatch "$PrivateNtwk"} | sort-object -Property name
