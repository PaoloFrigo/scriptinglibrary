#Paolo Frigo, https://www.scriptinglibrary.com
#This script need to run on the CRM Server 
#https://support.microsoft.com/en-au/help/907490/how-to-enable-tracing-in-microsoft-dynamics-crm

#Add-PSSnapin Microsoft.Crm.PowerShell
Param (
    [Parameter(Mandatory=$true)]    
    [ValidateSet("ON","OFF")]
    $Status 
)

#SETTINGS
$TraceLogDirectory = "D:\crmtracelogs\"

if (Test-Path $TraceLogDirectory){
    Throw "This file path for Trace Logs is NOT valid `"$TraceLogDirectory`""
}

$setting = Get-CrmSetting TraceSettings
if ($Status -eq "ON"){
    $setting.Directory = $TraceLogDirectory
    $setting.Enabled = $True
}
else {
    $setting.Enabled = $False
}

Set-CrmSetting $setting            
#Get-CrmSetting TraceSettings #Prints out the Settings
Write-Output "The Crm Tracing is now $Status and the tracing logs will be available on this directory $($setting.Directory)"