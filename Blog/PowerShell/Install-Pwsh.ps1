#requires -runasadministrator 
#Paolo Frigo, https://www.scriptinglibrary.com 

# DOWNLOAD AND INSTALL THE LATEST VERSION OF POWERSHELL
# BY USING THE MSI INSTALLER IN UNATTENDED/QUIET MODE.

Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -quiet"
