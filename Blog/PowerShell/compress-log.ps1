#requires -runasadministrator

# Paolo Frigo https://www.scriptinglibrary.compress

# List of Log Folders
$Logs =  "D:\Logs\W3SVC6", "D:\Logs\W3SVC5", "D:\Logs\W3SVC4", "D:\Logs\W3SVC3", "D:\Logs\W3SVC2"


$oldpath = $pwd

function compress-log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $LogDir
    )


    Set-Location $LogDir
    $Logs = $(Get-ChildItem *log)


    $counter = 1
    foreach ($log in $Logs){
        Write-Progress -Activity "Activity: Compressing $log" -Status "Compressing $log" -PercentComplete "$($counter/($logs.count)*100)"


        $Compress=@{
        Path = "$log"
        DestinationPath= "$log.zip"
        CompressionLevel = "Fastest"
        }
        Compress-Archive @Compress
        if (Test-Path $Compress.DestinationPath){
            Remove-Item $log
        }
        $counter = $counter + 1
    }
}


foreach ($LogFolder in $Logs){
    if (Test-Path $LogFolder){
        Write-Output "STARTING TO COMPRESS LOGS IN $LogFolder"
        compress-log -LogDir $LogFolder
    }
}
Set-Location $oldpath