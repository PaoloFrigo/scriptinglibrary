#requires -runasadministrator

#requires -runasadministrator

# Paolo Frigo, https://www.scriptinglibrary.com

$prefix = "lab-centos*"

Write-Output "This script will create a checkpoint immediately for all $prefix  VMs"
get-vm $prefix | checkpoint-vm
Write-Output "Activity completed"