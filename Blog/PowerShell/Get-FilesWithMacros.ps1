#requires -runasadministrator

<#
.Synopsis
    Get all office documents with Macros
.DESCRIPTION
    Get all office documents with Macros
.EXAMPLE
    Get a list of all documents with macros saved on a specific folder (in case SHARED FOLDER needs
    to be mapped in advance) and format the result as a table.

    PS D:\> Get-FilesWithMacros "d:\" | ft

    Directory Name                               LastWriteTime         LastAccessTime        Length
    --------- ----                               -------------         --------------        ------
    D:\       New Microsoft Excel Worksheet.xlsm 18/01/2018 6:45:27 PM 18/01/2018 6:45:27 PM   6164
    D:\       New Microsoft Word Document.docm   18/01/2018 6:45:33 PM 18/01/2018 6:45:33 PM      0

.EXAMPLE
   How to create a Report in CSV Format with all macro documents

   gfwm "d:\" | Export-CSV "Report_D_drive_macros.csv"

.NOTES
   Author Paolo Frigo  https://www.scriptinglibrary.com
#>
function Get-FilesWithMacros {
    [CmdletBinding()]
    [Alias('gfwm')]
    [OutputType([string])]
    Param
    (
        # Folder Name
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        $folder

    )
    Begin
    {
    }
    Process
    {
        #List of all Office Documents Extensions with Macros enabled
        $macro_extensions = ".docm", ".dotm", ".xlsm",".xlm", ".xltm", ".xla", ".pptm", ".potm", ".ppsm", ".sldm"
        get-childitem -Path $folder -Recurse -ErrorAction SilentlyContinue|  Where-Object { $macro_extensions -contains $_.Extension} | Select-Object Directory, Name, LastWriteTime, LastAccessTime, Length
    }
    End
    {
    }
}
