#requires -runasadministrator
#requires -module ActiveDirectory

# Paolo Frigo, https://www.scriptinglibrary.com
 
# Find Workstations with temporary files from Sophos To Remove

# SETTINGS
$WS = "*"                               #Replace with your pattern
$OU = "OU=Laptop, DC=Contoso, DC=com"   #Replace with your domain OU
#-----

$ComputerList = get-adcomputer -Filter {Name -like $WS} -SearchBase $OU | Select-Object -ExpandProperty name
$Total = $ComputerList.Count
$Counter = 1
foreach ($PC in $ComputerList) {
    if (Test-Connection -ComputerName $PC -quiet -count 1){
        write-progress -Activity "Searching on $PC" -PercentComplete $(($Counter/$total)*100)
        $SophosTempFiles = Get-ChildItem "\\$($PC)\c$\ProgramData\Sophos\Sophos Anti-Virus\Temp\*`$`$`$"
        if ($SophosTempFiles){
            Write-Output "$PC has $($SophosTempFiles.count) temp files to remove." 
        }   
    }
    $Counter += 1
}

Write-Output "$Total Workstations were scanned successfully"