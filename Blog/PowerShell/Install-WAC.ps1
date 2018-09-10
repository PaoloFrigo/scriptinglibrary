#requires -runasadministrator 

# Paolo Frigo, https://www.scriptinglibrary.com
#

#WINDOWS ADMIN CENTER DOCs
#https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/deploy/install

$WAC_Online = "http://aka.ms/WACDownload"
$WAC_Installer = "C:\windows\Temp\wac.msi"
$WAC_Log = "C:\windows\Temp\wac-installer.log"
Invoke-WebRequest -Uri $WAC_Online -OutFile $WAC_Installer
msiexec /i $WAC_Installer /qn SME_PORT=443 SSL_CERTIFICATE_OPTION=generate
