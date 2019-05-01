#Paolo Frigo, https://www.scriptinglibrary.com

<#
$Target = "Workstation1" #
# Open a remote powershell session
Enter-PSSession  -Credential $(get-credential -Message "Auth") -ComputerName $Target
# Enable Remote Desktop
(Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1) | Out-Null
(Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\TerminalServices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0) | Out-Null
Get-NetFirewallRule -DisplayName "Remote Desktop*" | Set-NetFirewallRule -enabled true
Exit-PSSession
#>

<#
.SYNOPSIS
    Enable RDP connections on the remote PC

.DESCRIPTION
    Enable RD Connection Services and Firewall Rules that will permit RDP connections to a remote PC.

.PARAMETER ComputerName
    Specify your target computer using a FQDN or IP

.EXAMPLE
    C:\PS>Enable-RemoteDesktopOnTarget -computername "172.16.0.5" -verbose
    VERBOSE: There are 2 IPs Available on network 172.16.0.*
    172.16.0.9
    172.16.0.10

.NOTES
    Author:  Paolo Frigo, https://www.scriptinglibrary.com
#>
function Enable-RemoteDesktopOnTarget{
    [CmdletBinding()]
    Param(
        # Parameter help description
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]
        $ComputerName
    )
    Begin{
    }
    Process{
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            # Enable Remote Desktop
            (Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1) | Out-Null
            (Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\TerminalServices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0) | Out-Null
            Write-Verbose -Message "$(get-date -Format [dd/MM/yyyy_hh:mm]) - Remote Desktop Services enabled on $ComputerName"
            Get-NetFirewallRule -DisplayName "Remote Desktop*" | Set-NetFirewallRule -enabled true
            Write-Verbose -Message "$(get-date -Format [dd/MM/yyyy_hh:mm]) - Firewall Rule enabled for RDP Connections on $ComputerName"
        }
    }
    End{
    }
}