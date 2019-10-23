#Paolo Frigo, https://www.scriptinglibrary.com

# This script enables remote connection on the target host, add a firewall rule to the winodws host based firewall and 
# tests if the standard RDP port is open.

# If you want to provide local admin credentials
# $cred = Get-Credential 

Param (
    [Parameter( Mandatory=$true,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true)]    
    $ComputerName 
)

#Tests if the host is the target host is reachable
if (test-connection -computername $ComputerName -quiet -count 1){
    #Enables The remote desktop connections
    invoke-command -computername $ComputerName -scriptblock {Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0} #-credential $cred
    #Adds a firewall rule
    invoke-command -computername $ComputerName -scriptblock {Enable-NetFirewallRule -DisplayGroup "Remote Desktop"} #-credential $cred
    if ((test-netconnection -computername $ComputerName -port 3389).TcpTestSucceeded -eq $True){
        Write-Output "Remote connection ENABLED, Firewall rule ADDED and RDP port OPEN on $ComputerName"
    }
    else{
        Write-Warning "The RDP port on $ComputerName is BLOCKED"
    }
}
else {
    Write-Warning "$ComputerName is not reachable"
}