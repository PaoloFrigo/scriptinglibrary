#Paolo Frigo, https://www.scriptinglibrary.com
#requires -runasadministrator

# This script will iterate through the list af all computers and search for a specific error in the Event Log

$ComputerList   = "PC1", "PC2", "PC3" # OR get-adcomputer -searchbase YOUR_WORKSTATION_OU -filter * | select-object -exp name 
$ResultLimit    = 5
$LogName        = "System"
$ErrorId        =  41  # Kernel-Power error (ID 41) -  The system has rebooted without cleanly shutting down first.
$ErrorDesc      = "Critical Reboot"

$ComputerList | ForEach-Object { if (Test-Connection $_ -quiet -count 1){write-host "$ErrorDesc for $_ "; Get-EventLog -ComputerName $_ -LogName $LogName -InstanceId $ErrorId  -newest $ResultLimit}}

