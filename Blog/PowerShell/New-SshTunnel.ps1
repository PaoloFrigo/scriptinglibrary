# Paolo Frigo, https://www.scriptinglibrary.com

# This scripts creates connect a local port to a remote port via an SSH tunnel 

# SCENARIO:  Poor-Man's VPN 
# HOST1 on NETWORKA wants to connect to HOST2 on NETWORKB,
# HOST2 is not exposed to the internet and there are not port-forwarding configured
# if there is an internet facing ssh server let's call it JUMPBOX available in
# the networkB that box can be used to tunnel the connection.

# SETTINGS
# -----------------------------------------------------------------------------------
#Local port
$LocalPort          =   "12345"         # HOST1

#Target box
$TargetBox          =   "192.168.1.94"  # HOST2
$TargetPort         =   "3389"          # RDP

#SSH Server                             #JUMPBOX
$Username           =   "PaoloF"         
$MyLinuxBox         =   "mylinuxbox.fqdn-or-Public-IP"   
$RemotePortForSSH   =   "22"                


# DEPENDENCY CHECK
# -----------------------------------------------------------------------------------
# This script requires PLINK, if is not present will be downloaded

try{
    $plinktest = Invoke-expression "plink2.exe"
}
catch{
    Write-Warning "Plink is dependency is missing. Downloading from the internet the latest version of PLINK."
    Invoke-WebRequest "https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe" -o "plink.exe"
    If(Test-Path "plink.exe"){
        Write-Output "Download of PLINK completed!"
    }
}

Write-Output "Creating the SSH Tunnel using port-fw"
invoke-expression "plink.exe -P $($RemotePortForSSH) -L $($LocalPort):$($TargetBox):$($TargetPort) $($Username)@luna.hsd.com.au"