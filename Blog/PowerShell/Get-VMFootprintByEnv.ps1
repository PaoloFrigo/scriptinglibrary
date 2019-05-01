#requires -runasadministrator
#requires -modules ActiveDirectory

#
# Paolo Frigo, https://www.scriptinglibrary.com
# This script will sum all VM Footprints according to your naming convention filter PROD/TEST/DEV used.
#
# VMNODES will list all hyper-v hosts


$Filter = "prod" # prod, test or dev
$VMNODES = "VMNode-01", "VMNode-02", "VMNode-03" #get-adcomputer -filter {name -like "My_Naming_Convention"} | Select-object -expandproperty name
$Result = 0

foreach ($VMHost in $VMNODES) {
    if (Test-Connection $VMHost -Quiet -Count 1) {
        $VM = get-vm -computername $VMHost | Where-Object {$_.name -match "$Filter"}
        $Disks = $VM | Get-VMHardDiskDrive | Select-object -expandproperty path
        $total_size = Invoke-Command -ComputerName $VMHost -ScriptBlock {
            param($Disks)
            $total = 0
            #write-host $disks
            foreach ($disk in $disks) {
                $size = [math]::round((get-item -Path $disk | select-object -ExpandProperty length)/1GB,2)
                write-host "Disk: $disk `t Size $size GB"
                $total += $size
            }
            return $total
            } -ArgumentList (,$Disks)
        $Result += $total_size
     }
    else {
        raise "$VMHost is not reachable"
    }
}

Write-Output "$Filter VM footprint is $Result GB".ToUpper()