Import-Module -Name "virtualmachinemanager"
#Paolo Frigo, https://www.scriptinglibrary.com 

# SETTINGS
$BackupRepository = "\\YOUR\REPOSITORY\" 
$VMList = Get-SCVirtualMachine -VMMServer "scvmm.fqdn"

function Split-VEEAMBackupFile($VMBackupFileName){
    if ($VMBackupFileName.Substring($VMBackupFileName.length-9,1) -eq "_"){
        $VeeamDateSize = 27
    }
    else{
        $VeeamDateSize = 22
    }
    $VMNAme = $VMBackupFileName.Substring(0,$VMBackupFileName.Length-$VeeamDateSize)
    $DateString = $VMBackupFileName.Substring($VMNAme.Length+1, 10)
    $TimeString = "$($VMBackupFileName.Substring($VMNAme.Length+12,2)):$($VMBackupFileName.Substring($VMNAme.Length+14,2)):$($VMBackupFileName.Substring($VMNAme.Length+16,2))"
    $Datetime = "$DateString $Timestring" | Get-Date
    return $VMNAme,$Datetime    
}
function Set-LastBackupProperty
{
    param(
    [Parameter(Mandatory=$true, Position=0)]
    [string] $VMName,       
    [Parameter(Mandatory=$true, Position=1)]
    [string] $LastBackupTime
    )
    $VM = $VMList | Where-Object {$_.Name -match "$VMName"}  #Get-SCVirtualMachine -Name "$VMName"
    $CustomProp = Get-SCCustomProperty -Name "LastBackup"
    $VM | Set-SCCustomPropertyValue -CustomProperty $CustomProp -Value "$LastBackupTime"
}
$BackupFiles = Get-ChildItem $BackupRepository |Sort-Object Name -Descending | Where-Object {$_.Name -like "*.vbk" -and $_.Length -gt 22MB}|  Select-Object -exp name
$VeeamFullBackup = @{}
foreach ($VMBackupFileName in $BackupFiles){
    $BackupRecord =  Split-VEEAMBackupFile($VMBackupFileName)   
    try{
        $VeeamFullBackup.add($BackupRecord[0],$BackupRecord[1])         
    }
    catch{
        #Write-warning "The Backup for $($BackupRecord[0]) has already a more recent backup than the one taken at  $($BackupRecord[1]) "
    }
}
foreach ($vmname in $VeeamFullBackup.Keys){
    $Datetime = $VeeamFullBackup["$vmname"].ToString("dd/MM/yyyy hh:mm")
    #Write-Output "Setting for $vmname the LastBackup custom Property to $Datetime"
    Set-LastBackupProperty -VMNAme "$vmname" -LastBackupTime "$Datetime"
}
exit 0