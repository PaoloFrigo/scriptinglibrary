# Paolo Frigo, https://www.scriptinglibrary.com

# This scripts creates connect a local port to a remote port via an SSH tunnel 

# SCENARIO:  POOR-MAN'S VPN 
#
# HOST1 on NETWORKA wants to connect to HOST2 on NETWORKB,
# HOST2 is not exposed to the internet and there are not port-forwarding configured
# if there is an internet facing ssh server let's call it JUMPBOX available in
# the networkB that box can be used to tunnel the connection.

# SETTINGS
# -----------------------------------------------------------------------------------
#Local port
$LocalPort          =   "12345"         # HOST1 can be on 10.1.2.4/24 NETWORKA

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
    $plinktest = Invoke-expression "plink.exe"
}
catch{
    Write-Warning "PLINK DEPENDENCY IS MISSING. Downloading the latest version of PLINK.."
    Invoke-WebRequest "https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe" -o "plink.exe"
    If(Test-Path "plink.exe"){
        Write-Output "Download completed!"
    }
}

Write-Output "CREATING THE SSH TUNNEL USING PORT-FW"
invoke-expression "plink.exe -P $($RemotePortForSSH) -L $($LocalPort):$($TargetBox):$($TargetPort) $($Username)@$($MyLinuxBox)"