#Paolo Frigo, https://www.scriptinglibrary.com
#https://support.microsoft.com/en-au/help/907490/how-to-enable-tracing-in-microsoft-dynamics-crm

Add-PSSnapin Microsoft.Crm.PowerShell

$setting = Get-CrmSetting TraceSettings
$setting.Enabled = $False

Set-CrmSetting $setting
Get-CrmSetting TraceSettings

Write-OutPut "The Crm Tracing is now DISABLED"
pause