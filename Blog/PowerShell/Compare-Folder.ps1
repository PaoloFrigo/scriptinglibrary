#Paolo Frigo, https://scriptinglibrary.com

<#
    .SYNOPSIS
    Compare the contents of two folders based on file hashes.

    .DESCRIPTION
    This script calculates SHA256 hashes for all files in two specified folders 
    (and their subdirectories) and compares them. It outputs any differences 
    in file content or structure.

    .PARAMETER Folder1
    The absolute path to the first folder to compare.

    .PARAMETER Folder2
    The absolute path to the second folder to compare.

    .EXAMPLE
    Compare-Folders.ps1 -Folder1 "C:\Path\To\Folder1" -Folder2 "C:\Path\To\Folder2"
    
    This compares the contents of "Folder1" and "Folder2" and outputs any differences.

    .NOTES
    Author: Paolo Frigo
#>

param (
    [Parameter(Mandatory)]
    [string]$Folder1, 

    [Parameter(Mandatory)]
    [string]$Folder2  
)

$folder1Hashes = Get-ChildItem -Path $Folder1 -File -Recurse |
    ForEach-Object {
        [PSCustomObject]@{
            RelativePath = $_.FullName.Substring($Folder1.Length)
            Hash = (Get-FileHash $_.FullName).Hash
        }
    }

$folder2Hashes = Get-ChildItem -Path $Folder2 -File -Recurse |
    ForEach-Object {
        [PSCustomObject]@{
            RelativePath = $_.FullName.Substring($Folder2.Length)
            Hash = (Get-FileHash $_.FullName).Hash
        }
    }

$differences = Compare-Object $folder1Hashes $folder2Hashes -Property RelativePath, Hash -PassThru

if ($differences) {
    Write-Host "Differences found:"
    $differences | Format-Table
} else {
    Write-Host "The folders are identical."
}