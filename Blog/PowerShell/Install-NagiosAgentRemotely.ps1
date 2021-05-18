<#
Paolo Frigo, https://scriptinglibrary.com

.Synopsis
   Install remotely the NSCP++ agent for Nagios
.DESCRIPTION
   This script allow you to install remotely the NSCP++ agent for Nagios to a target windows computer (server/workstation).
   Included in the installation process is also the deployment of a custom configuration file and the custom powershell scripts for whitebox monitoring.
.EXAMPLE
    install-nagiosagentremotely  
#>


$MsiInstaller = "NSCP-0.4.1.73-x64.msi" #Or a newer version
$port = "12489"
$NAS = "\\YOUR_UNC_PATH\Nagios\" #Installation folder

function Install-NSCP
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $target
    )

    Begin
    {
        if ((Test-NetConnection -computername $Target -Port $port).TcpTestSucceeded -eq $true){
            Write-Warning "NSCP++ is already running on $Target"
            exit
        }

    }
    Process
    {
        $OldPath = (Get-Location).path
        Set-Location $NAS

        Write-Information "`n-Copying the installer on the windows temp folder"
        Copy-Item -path ".\$MsiInstaller" -Destination \\$Target\C$\windows\Temp\

        Write-Information "-Installing the app"
        #IMPORTANT: Pay attention that the installer is hard-coded in the following scriptblock
        invoke-command -ComputerName $Target -ScriptBlock {Start-Process "msiexec" -ArgumentList '/qn /i c:\windows\temp\NSCP-0.4.1.73-x64.msi INSTALLLOCATION="C:\Program Files\NSClient++" CONFIGURATION_TYPE=registry://HKEY_LOCAL_MACHINE/software/NSClient++ ADDDEFAULT=ALL REMOVE=PythonScript' -wait  -NoNewWindow}

        Write-Information "-Stopping the service"
        invoke-command -ComputerName $Target -ScriptBlock { Stop-Service nscp }

        Write-Information "-Making a Backup copy of the Nagios Client"
        Move-Item -path "\\$Target\c$\Program Files\NSClient++\nsclient.ini" -Destination "\\$Target\c$\Program Files\NSClient++\nsclient.ini.dist" -Force

        Write-Information "-Copying the new nsclient.ini file"
        Copy-Item -path ".\nsclient.ini" -Destination "\\$Target\c$\Program Files\NSClient++\"

        Write-Information "-Copying New Custom Powershell scripts"
        Copy-Item -path ".\*.ps1" -Destination "\\$Target\c$\Program Files\NSClient++\scripts"

        Write-Information "-Restarting the service"
        invoke-command -ComputerName $Target -ScriptBlock { Start-Service nscp }

        Set-Location $oldpath

        start-sleep -Seconds 5
        Write-Output "-Checking it the port on the target server for the NSCP server is:"
        if ((Test-NetConnection -computername $Target -Port $port).TcpTestSucceeded -eq $true){
            Write-Output "-OPEN - NSCP++ is working as expected on $Target `n`nInstallation completed successfully."
        }
        else {
            Write-Warning "-CLOSED - Port $port on $Target is closed NSCP is not running, not installed correctly or a firewall rule maybe is blocking it"
        }
    }
    End
    {
    }
}

Install-NSCP