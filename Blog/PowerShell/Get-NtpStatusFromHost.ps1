#Requires -RunAsAdministrator
#
#   Paolo Frigo, www.scriptinglibrary.com
#
function Get-NTPStatusFromHost {
    <#

        .Synopsis
            Get NTP status from a host
        .Description
            Get the Network Time Protocol (NTP) status from a host. It's a simple a W32tm Wrapper.

        .Example
            Get-NTPStatusFromHost  -Computername localhost

            This shows the NTP Status of the localhost, this will be the result:

            NTP STATUS FOR localhost
            Leap Indicator: 0(no warning)
            Stratum: 7 (secondary reference - syncd by (S)NTP)
            Precision: -6 (15.625ms per tick)
            Root Delay: 0.0079510s
            Root Dispersion: 0.3620458s
            ReferenceId: 0xC0A86302 (source IP:  192.168.0.2)
            Last Successful Sync Time: 23/05/2017 10:43:37 PM
            Source: dc1.contoso.com
            Poll Interval: 15 (32768s)

        .Example
            get-adcomputer -searchbase ‘OU=workstations,dc=contoso,dc=com’ -filter * -property * | select name  | Get-NTPStatusFromHost

            This shows the NTP Status for all the workstation in AD.

        .Notes
              Author: Paolo Frigo - https://www.scriptinglibrary.com

    #>
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [Alias('Name')]

        [string[]]$ComputerName
    )
    Process {
        write-output "NTP STATUS FOR $ComputerName"
        w32tm /query /computer:$ComputerName /status
    }
}