#todo: add 7zip options if available

function Compress-Folder {
    <#
    .SYNOPSIS        
       
    .DESCRIPTION
        
    .PARAMETER FolderName

    .PARAMETER RemoveDirWhenFinished

    .EXAMPLE
        Compress-Folder  -FolderName  "/Users/paolofrigo/Documents/scriptinglibrary/Blog/PowerShell/tmp"
        
    .NOTES
        Author: paolofrigo@gmail.com, https://www.scriptinglibrary.com
    
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
        $FolderNameFullPath=(Resolve-Path $FolderName).Path        
        $DestinationFullPath="$FolderNameFullPath.zip"
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