#Paolo Frigo, https://www.scriptinglibrary.com
#https://support.microsoft.com/en-au/help/907490/how-to-enable-tracing-in-microsoft-dynamics-crm

Add-PSSnapin Microsoft.Crm.PowerShell

$setting = Get-CrmSetting TraceSettings
$setting.Enabled = $True
$setting.Directory = "D:\crmtrace\logs\"

Set-CrmSetting $setting
Get-CrmSetting TraceSettings

Write-Output "The Crm Tracing is now ENABLED and the tracing logs will be available on this directory $($setting.Directory)"
pause