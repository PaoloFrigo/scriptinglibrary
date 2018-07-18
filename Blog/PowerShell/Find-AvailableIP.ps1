<#
.SYNOPSIS
    Get available IPs on the network

.DESCRIPTION
    Get a list of all IPs on the network which don't respond to ICPM protocol.

.PARAMETER Network
    Specify your network using a '*' symbol, for example 10.0.0.*

.EXAMPLE
    C:\PS>Find-AvailableIP -Network"172.16.0.*" -verbose
    VERBOSE: There are 2 IPs Available on network 172.16.0.*
    172.16.0.9
    172.16.0.10

.EXAMPLE
    C:\PS> "172.16.0.*" | Find-AvailableIP
    172.16.0.9
    172.16.0.10

.EXAMPLE
    C:\PS> "10.0.0.*", "10.0.1.*" | Find-AvailableIP -Verbose
    VERBOSE: There are 2 IPs Available on network 10.0.0.*
    10.0.0.2
    10.0.0.5
    VERBOSE: There are 3 IPs Available on network 10.0.1.*
    10.10.1.2
    10.10.1.3
    10.10.1.5
.NOTES
    Author:  Paolo Frigo, https://www.scriptinglibrary.com
#>

function Find-AvailableIP {
    [CmdletBinding()]
    [OutputType([string])]

    param(
        #check if the IP Address belong to a private class A,B or C
        [parameter(ValueFromPipeline, Mandatory = $true)]
        [ValidateScript( {$_ -match "^(10\.|172\.16\.|192\.168\.|)[0-9.]*(\*$)"})]
        [string]
        $Network
    )

    Begin {
    }
    Process {
        $counter = 0
        $Results = @()
        $IPs = 1 .. 254
        foreach ($IP in $IPs) {
            $counter += 1
            $IpAddress = $Network.Replace("*", $IP)
            Write-Progress -activity "Testing subnet $Network" -status "$IpAddress" -PercentComplete (($counter / ($IPs.Length)) * 100)
            if ( (Test-Connection -computername "$IpAddress" -quiet -count 1 ) -eq $False) {
                $Results += $IpAddress
            }
        }
        Write-Verbose "There are $($Results.Length) IPs available on network $Network"
        Write-OutPut $Results
    }
    End {
    }
}