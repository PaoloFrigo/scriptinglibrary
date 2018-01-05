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
.AUTHOR paolofrigo@gmail.com , 2018 https://www.scriptinglibrary.com
#>
function Decode-SecureStringPassword
{
    [CmdletBinding()]
    [Alias('dssp')]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,                   
                   Position=0) ]     
        $password 
    )
    Begin
    {
    }
    Process
    {        
       return [System.Runtime.InteropServices.Marshal]::PtrToStringUni([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password))              
    }
    End
    {
    }
}

