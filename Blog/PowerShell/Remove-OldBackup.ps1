#PF,2019  https://www.scriptinglibrary.com

<#

    .Synopsis
        This function Remove-OldBackup will retain the latest N copy on a database from a specified folder

    .Description
        This function Remove-OldBackup will retain the latest N copy on a database from a specified folder


    .Example
        Remove-OldBackup -Folder $Folder -Database $Database -KeepLast $KeepLast
        Remove from $Folder all $Database like files and keep the most recent number ($keeplast) of files

    .Notes
        Remember to use the dot-surcing notation to import this function before calling the Remove-OldBackup cmd-let.
        Please add a -Confirm if needed
        Author: Paolo Frigo,  https://www.scriptinglibrary.com


#>
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

# SETTINGS
#$Folder = "D:\temp\Backup\"     #backup folder
#$Database = "db*bak"            #database name
#$KeepLast = 2                   #retain just last 2 copies
#example
#Remove-OldBackup -Folder $Folder -Database $Database -KeepLast $KeepLast