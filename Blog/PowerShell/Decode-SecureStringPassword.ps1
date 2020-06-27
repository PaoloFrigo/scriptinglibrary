<#
.Synopsis
   Tries to decode a SecureString and returns its clear text value
.DESCRIPTION
   Tries to decode a SecureString from a PSCredential Object and returns its clear text value
.EXAMPLE
   get-credential | Decode-SecureStringPassword
.EXAMPLE
   get-credential | dssp
.EXAMPLE
   Decode-SecureStringPassword -password SecureString

.Notes
    Author: Paolo Frigo  https://www.scriptinglibrary.com

#>
function Decode-SecureStringPassword {
    [CmdletBinding()]
    [Alias('dssp')]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true,
        Position = 0) ]
        [SecureString] $password
    )
    Begin {
    }
    Process {
        return [System.Runtime.InteropServices.Marshal]::PtrToStringUni([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password))
    }
    End {
    }
}

