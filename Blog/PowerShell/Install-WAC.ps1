#requires -runasadministrator

# Paolo Frigo, https://www.scriptinglibrary.com

#WINDOWS ADMIN CENTER DOCs
#https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/deploy/install

$WAC_Online = "http://aka.ms/WACDownload"
$WAC_Installer = "C:\windows\Temp\wac.msi"
$Port = 443

# Leave it blank if you want to generate a Self-Signed Certificate.
$CertificateThumbprint = ""
$IsAdminCenterInstalled = [bool] (Get-WmiObject -class win32_product  | Where-Object {$_.Name -eq "Windows Admin Center"})

If ($IsAdminCenterInstalled){
    $ReInstall = Read-Host "Admin Center is already installed. Do you want to re-install/upgrade it? [Y/N]"
    If ( ("N","n") -contains $ReInstall){
        Write-Warning "Ok, No further action is required."
        Exit 0
    }
}
Invoke-WebRequest -Uri $WAC_Online -OutFile $WAC_Installer
#if CertificateThumbprint is defined and installed on the system will be used during the installation
if ([bool](get-childitem cert: -recurse | where-object {$_.thumbprint -eq $CertificateThumbprint})){
    msiexec /i $WAC_Installer /qn SME_PORT=$Port  SME_THUMBPRINT=$CertificateThumbprint SSL_CERTIFICATE_OPTION=installed
}
else{
    msiexec /i $WAC_Installer /qn SME_PORT=$Port SSL_CERTIFICATE_OPTION=generate
}

#Post Installation Checks
do {
    if ((Get-Service ServerManagementGateway).status -ne "Running"){
        Write-Output "Starting Windows Admin Center (ServerManagementGateway) Service"
        Start-Service ServerManagementGateway
    }
    Start-sleep -Seconds 5
} until ((Test-NetConnection -ComputerName "localhost" -port $Port).TcpTestSucceeded)

Write-Output "Installation completed and Windows Admin Center is running as expected."