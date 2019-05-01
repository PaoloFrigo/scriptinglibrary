#requires -runasadministrator

#
# Paolo Frigo, https://www.scriptinglibrary.com
# This script will get the size of all VHDX files of all VMs hosted on your Hyper-V
#
# notes -   Please have a look to get-vmfootprintbyenv.ps1 in case you want to run this
#           script against multiple hyper-v hosts

function Get-VMFootprint ($VM){
    $total_size = 0
    foreach ($disk in  ($VM | Get-VMHardDiskDrive | Select-object -expandproperty path) ){
        $total_size += Get-Item $disk | Select-Object -ExpandProperty Length
    }
    Return [math]::round($total_size/1GB,2)
}

$counter = 0
$vm_counter = 0
$total = 0

foreach ($VMHost in $ALL_HSD_VM_NODES){
    $counter += 1
    foreach ($VM in (get-vm -computername $VMHost)){
        $vm_counter += 1
        Write-Progress -Status "Get Footprint of $($VM.Name)" -Activity "Retrieve information from $($VmHost)"  -PercentComplete $($counter/$NumNodes*100)
        $VmSize = $(Get-VMFootprint($VM))
        Write-Verbose "$($VM.Name) - $VmSize GB"
        $total += $VmSize
    }
}

Write-Output "$vm_counter VMs Footprint: $total GB "
