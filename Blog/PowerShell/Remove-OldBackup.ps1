#PF,2019  https://www.scriptinglibrary.com 

# SETTINGS

$Folder = "D:\temp\Backup\"     #backup folder 
$Database = "db*bak"            #database name 
$KeepLast = 2                   #retain just last 2 copies
 
function Remove-OldBackup{
    [CmdletBinding()]
    param ( 
        [Parameter(Mandatory=$true)]   
        [ValidateScript({Test-Path $_})]      
        [string] $Folder,
        [Parameter(Mandatory=$true)]
        [String] $Database,
        [Parameter(Mandatory=$true)]
        [int] $KeepLast
    )     
    $ExcludeFiles = Get-ChildItem -Path $Folder | Where-Object {$_.Name -like $Database} |Sort-Object  -Property CreationTime | Select-Object -last $KeepLast -ExpandProperty Name 
    Get-ChildItem -Path $Folder -Exclude ($ExcludeFiles) | Where-Object {$_.Name -like $Database} | Remove-Item #-confirm 
}

#example 
Remove-OldBackup -Folder $Folder -Database $Database -KeepLast $KeepLast