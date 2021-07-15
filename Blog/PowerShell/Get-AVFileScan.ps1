#requires -module defender

#Paolo Frigo, https://www.scriptinglibrary.com

<#
.Synopsis
   Wrapper function of the Microsoft Defender on demand scanner feature
.DESCRIPTION
   Wrapper function of the Microsoft Defender on demand scanner feature with a built-in check for AV signature update.
.PARAMETER file
   Full path of the file to scan with the AV
.EXAMPLE
   Get-AVFileScan -file "FULL_PATH_OF_YOUR_FILE"
.EXAMPLE
   Get-AVFileScan -file "FULL_PATH_OF_YOUR_FILE" -verbose
#>
function Get-AVFileScan
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
         [ValidateScript({Test-Path $_ })]
         [string]
        $file
    )

    Begin
    {
         if ((Get-MpComputerStatus).AntivirusSignatureLastUpdated -lt $(Get-Date).adddays(-2)) {
            Write-Warning "Your AV definitions are older than 2 days. Launching the Signature Update."
            Update-MpSignature -Verbose
         }
    }
    Process
    {
        $DefenderFolder = (Get-ChildItem "C:\ProgramData\Microsoft\Windows Defender\Platform\" | Sort-Object -Descending | Select-Object -First 1).fullname
        $Defender = "$defenderFolder\MpCmdRun.exe"
        $output = & $Defender -scan -scantype 3 -file (get-item $file).FullName
        $output | ForEach-Object {Write-Verbose $_}

        return $output[-1] -notmatch "no threats"
    }
    End
    {
    }
}


