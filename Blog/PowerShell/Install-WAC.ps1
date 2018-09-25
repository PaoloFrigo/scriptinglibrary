#requires -runasadministrator 

# Paolo Frigo, https://www.scriptinglibrary.com
#

#WINDOWS ADMIN CENTER DOCs
#https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/deploy/install

$WAC_Online = "http://aka.ms/WACDownload"
$WAC_Installer = "C:\windows\Temp\wac.msi"
$Port = 443

$IsAdminCenterInstalled = [bool] (Get-WmiObject -class win32_product  | Where-Object {$_.Name -eq "Windows Admin Center"})

If ($IsAdminCenterInstalled){
    $ReInstall = Read-Host "Admin Center is already installed do you want to re-install or upgrade it? [Y/N]"
    If ( ("N","n") -contains $ReInstall){
        Write-Warning "Windows Admin Center is already installed and no further action is required."   
        Exit 0
    }
}

Invoke-WebRequest -Uri $WAC_Online -OutFile $WAC_Installer
msiexec /i $WAC_Installer /qn SME_PORT=$Port SSL_CERTIFICATE_OPTION=generate

#Post Installation Checks
do {
    if ((Get-Service ServerManagementGateway).status -ne "Running"){
        Write-Output "Starting for Windows Admin Center"
        Start-Service ServerManagementGateway
    }
    Start-sleep -Seconds 5
} until ((Test-NetConnection -ComputerName "localhost" -port $Port).TcpTestSucceeded)
Write-Output "Installation completed and Windows Admin Center is running as expected."