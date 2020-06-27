#requires -runasadministrator

<#
.Synopsis
    Modify proxy settings for the current user.

.DESCRIPTION
    Modify proxy settings for the current user modifying the windows registry.

.EXAMPLE
    Get the proxy settings for the current user

    PS D:\> get-proxy
    ProxyServer ProxyEnable
    ----------- -----------
                        0

.EXAMPLE
   Set the proxy server for the current user. Test the address and if the TCP Port is open before applying the settings.
   proxy squid.server.com 3128    # or   set-proxy -server "yourproxy.server.com" -port 3128

.EXAMPLE
   Remove the current proxy settings for the user.

.NOTES
   Author Paolo Frigo https://www.scriptinglibrary.com
#>

function Get-Proxy (){
    Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object ProxyServer, ProxyEnable
}

function Set-Proxy {
    [CmdletBinding()]
    [Alias('proxy')]
    [OutputType([string])]
    Param
    (
        # server address
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        $server,
        # port number
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1)]
        $port
    )
    #Test if the TCP Port on the server is open before applying the settings
    If ((Test-NetConnection -ComputerName $server -Port $port).TcpTestSucceeded) {
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value "$($server):$($port)"
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 1
        Get-Proxy #Show the configuration
    }
    Else {
        Write-Error -Message "The proxy address is not valid:  $($server):$($port)"
    }
}

function Remove-Proxy (){
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value ""
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 0
}

