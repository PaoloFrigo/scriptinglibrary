# Paolo Frigo, https://www.scriptinglibrary.com

# This script will monitor the chosen processes and output the selected informations onto a csv file.

$ProcessName = "*"
$LogFile = $PSScriptRoot+"\MyCustomLogs.csv"


#Creates the file if it doesn't exists adding the header for the CSV
if ((Test-Path $LogFile) -eq $False){
    Set-Content -Value "Date, ProcessName, ID, CPU, Mem, TotalRAM" -Path $LogFile
}

$datetime = Get-Date -Format "dd/M/yyyy hh:mm:ss"
$total_mem=(systeminfo | Select-String 'Total Physical Memory:').ToString().Split(':')[1].Replace(" ", "")
$processes=get-process $ProcessName| Select-Object PM, CPU, Name, Id #Selected fields for the processes

foreach ($proc in $processes){
     Add-Content -Value "$($datetime), $($proc.Name), $($proc.ID), $($proc.CPU), $([math]::Round($proc.PM/(1024*1024),2))MB, $($total_mem)" -Path $LogFile 
}
exit 0