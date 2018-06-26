#Paolo Frigo, https://www.scriptinglibrary.com
$Target = "Workstation1" #
# Open a remote powershell session
Enter-PSSession  -Credential $(get-credential -Message "Auth") -ComputerName $Target
# Enable Remote Desktop
(Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1) | Out-Null
(Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\TerminalServices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0) | Out-Null
Get-NetFirewallRule -DisplayName "Remote Desktop*" | Set-NetFirewallRule -enabled true
Exit-PSSession