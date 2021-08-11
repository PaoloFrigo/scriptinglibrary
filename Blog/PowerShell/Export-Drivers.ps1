#Requires -RunAsAdministrator

# Paolo Frigo, https://scriptinglibrary.com

# More details on:
# https://docs.microsoft.com/en-us/powershell/module/dism/export-windowsdriver?view=windowsserver2019-ps#examples

$DestinationFolder="D:\Drivers\"

if (Test-Path -Path $DestinationFolder){
    Export-WindowsDriver -Online -Destination $DestinationFolder
}
else {
    Write-Error "Invalid Path: $DestinationFolder"
}

