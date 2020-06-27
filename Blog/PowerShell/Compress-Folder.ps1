function Compress-Folder {
    <#
    .SYNOPSIS
        Compress a folder and remove the directory if needed.

    .DESCRIPTION
        This function is a wrapper of Compress-Archive for PowerShell versions greater or equal to 5 or
        if not it leverages ZipFile class from .NET Framework to achieve the same result providing backward
        compatibility.  If RemoveDirWhenFinished parameter is set to $True the target directory will be
        removed after compression.

    .PARAMETER FolderName
        FolderName parameter is required to specify which folder you want to compress

    .PARAMETER RemoveDirWhenFinished
        RemoveDirWhenFinished parameter is optional, if the compression task succeeded and the parameter
        is set to $True the "FolderName" target directory will be removed.

    .EXAMPLE
        Compress-Folder  -FolderName  "/Users/paolofrigo/Documents/tmp_folder_01"

        Creates an archive named "tmp_folder_01.zip" on the parent path.

    .EXAMPLE
        Compress-Folder  -FolderName  "D:\Logs\temp01" -RemoveDirWhenFinished $True

        Creates an archive named "temp01.zip" and it removes the folder when finished.

    .NOTES
        Author: Paolo Frigo  https://www.scriptinglibrary.com

    #>
    [CmdletBinding()]  # Add cmdlet features.
    Param (
        [Parameter(Mandatory = $True)]
        [string]$FolderName,
        [Parameter(Mandatory = $False)]
        [bool]$RemoveDirWhenFinished
    )
    Begin {
        $PSVersion = $PSVersionTable.PSVersion.Major
        $FolderNameFullPath = (Resolve-Path $FolderName).Path
        $DestinationFullPath = "$FolderNameFullPath.zip"
        $Destination = "$Foldername.zip"
    }
    Process {
        if (Test-Path -path $FolderNameFullPath) {
            If (Test-path $DestinationFullPath) {
                Remove-Item $DestinationFullPath #-confirm
            }
            try {
                if (($PSVersion -ge 5) -and (Get-ChildItem -path $FolderNameFullPath).count -gt 0) {
                    Compress-Archive -Path $FolderNameFullPath -DestinationPath $DestinationFullPath -Force -CompressionLevel Optimal
                }
                else {
                    Add-Type -assembly "system.io.compression.filesystem"
                    [io.compression.zipfile]::CreateFromDirectory($FolderNameFullPath, $DestinationFullPath)
                }
                Write-Verbose "Archive Created: $Destination"
                if ((test-path -path $DestinationFullPath) -and $RemoveDirWhenFinished -eq $True) {
                    Remove-Item -Recurse -path $FolderNameFullPath
                    Write-Verbose "$FolderName removed."
                }
            }
            catch {
                Write-Error "Compression failed for $FolderName"
            }
        }
        else {
            Write-Error "Path not valid $FolderNameFullPath"
        }
    }
    End {

    }
}
