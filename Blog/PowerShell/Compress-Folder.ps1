
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
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