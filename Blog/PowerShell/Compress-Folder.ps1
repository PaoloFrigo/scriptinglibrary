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
            [Parameter(Mandatory=$True,Position=1,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
            [Alias("Name")]
            [string]$FolderName,
            [Parameter(Mandatory=$False)]            
            [bool]$RemoveDirWhenFinished = $False
            )
    
        Begin {
            $PSVersion = $PSVersionTable.PSVersion.Major
            $Destination = "$pwd\($FolderName).zip"               
        } 

        Process {
            if ($PSVersion -ge 5 ){
                Compress-Archive -Path $FolderName -DestinationPath $Destination
            } 
            else {
                If(Test-path $Destination) {
                    Remove-Item $Destination -confirm
                }
                Add-Type -assembly "system.io.compression.filesystem"
                Write-Output "$FolderName, $Destination"
                [io.compression.zipfile]::CreateFromDirectory($FolderName,$Destination)                 
            }
        } 
        End {
            Write-Output "--- $RemoveDirWhenFinished $FolderName"
            if ($RemoveDirWhenFinished -eq $True){
                Remove-Item  -Path $FolderName -Recurse 
            }
            Write-Verbose "Archive Created: $Destination"
        } 
    }