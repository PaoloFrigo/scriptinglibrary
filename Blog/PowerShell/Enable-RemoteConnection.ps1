#Paolo Frigo, https://www.scriptinglibrary.com

#This scripts enable the remote connection to the target host, add a firewall rule and test if the port is open.

# If you want to provide local admin credentials
# $cred = Get-Credential 

$target = Read-host "Enter the target computername"

if (test-connection -computername $target -quiet -count 1){
    #Enable The remote desktop connections
    invoke-command -computername $target -scriptblock {Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0} #-credential $cred
    invoke-command -computername $target -scriptblock {Enable-NetFirewallRule -DisplayGroup "Remote Desktop"} #-credential $cred
    if ((test-netconnection -computername $target -port 3389).TcpTestSucceeded -eq $True){
        Write-Output "Remote connection ENABLED, Firewall rule ADDED and RDP port OPEN on $target"
    }
}
else {
    Write-Warning "$target is not reachable"
}