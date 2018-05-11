#todo: add 7zip options if available

function Compress-Folder {
    <#
    .SYNOPSIS
       
    .DESCRIPTION
        
    .PARAMETER FolderName

    .EXAMPLE
        Compress-Folder  -FolderName  "/Users/paolofrigo/Documents/scriptinglibrary/Blog/PowerShell/tmp"
        
    .NOTES
        Author: paolofrigo@gmail.com, https://www.scriptinglibrary.com
    
    #>
        [CmdletBinding()]  # Add cmdlet features.
        Param (
            [Parameter(Mandatory=$True)]
            [string]$FolderName,
            $destination = "$FolderName.zip"
            )
    
        Begin {
            $PSVersion = $PSVersionTable.PSVersion.Major   
        } 

        Process {
            if ($PSVersion -gt 5 ){
                Compress-Archive -Path $FolderName -DestinationPath $destination
            } 
            else {
                If(Test-path $destination) {
                    Remove-Item $destination -confirm
                }
                Add-Type -assembly "system.io.compression.filesystem"
                [io.compression.zipfile]::CreateFromDirectory($FolderName, $destination) 
            }
        } 
        End {
            Write-Verbose "Archive Created: $destination"
        } 
    }