#Paolo Frigo, https://scriptinglibrary.com

#This is a simple powershell script to monitor MS Defender for Endpoints and it can be used with Nagios Core / Nagios XI
 
$DefenderRunninigAndRealTimesOn = $(Get-Service Windefend).Status -eq "Running" -and $(Get-MpComputerStatus).RealTimeProtectionEnabled
$ExitStatus = 0
$Message = "OK"
if ($DefenderRunninigAndRealTimesOn -eq $False){
    $Message = "CRITICAL - Microsoft Defender is not running or the real-time protection was disabled"
    $ExitStatus = 2        
}
if ([bool] (Get-MpThreatDetection) -eq $True){
    $Message = "CRITICAL - Microsoft Defender has detected some threats recently"
    $ExitStatus = 2        
}
if ([bool]((Get-MpComputerStatus).AntivirusSignatureLastUpdated -lt (Get-date).AddDays(-7)) -eq $True) {
    $Message = "CRITICAL - Microsoft Defender AV Definitions are older than a week"
    $ExitStatus = 2 
}
Write-Output $Message
exit $ExitStatus