<#
.SYNOPSIS
Add bulk IP filtering to IIS Website

Based on Aaron Guilmette solution:
https://www.undocumented-features.com/2018/02/08/implementing-geo-filtering-with-iis/

PLEASE NOTE:
I recommend using the -OnlyExportIPSecurityXML otherwise for thousands of subnets this process
can take several hours. 
In IIS you’ll also need to update or verify the allow/deny policy of the site (IIS | Sites | <site> | IP Address and Domain Restrictions | Edit Feature Settings and review the value for “Access for unspecified clients”) to DENY

#>

param (
    $Logfile = (Get-Date -Format yyyy-mm-dd-hh-mm) + "_" + $($MyInvocation.MyCommand) + "_.txt",
    [switch]$OnlyExportIPSecurityXML,
    $Output = "IPSecurityXML.txt",
    $Site = "Default Web Site",
    $Source)

#### Begin Function declaration

function Write-Log([string[]]$Message, [string]$LogFile = $Script:LogFile, [switch]$ConsoleOutput, [ValidateSet("SUCCESS", "INFO", "WARN", "ERROR", "DEBUG")][string]$LogLevel)
{
    $Message = $Message + $Input
    If (!$LogLevel) { $LogLevel = "INFO" }
    switch ($LogLevel)
    {
        SUCCESS { $Color = "Green" }
        INFO { $Color = "White" }
        WARN { $Color = "Yellow" }
        ERROR { $Color = "Red" }
        DEBUG { $Color = "Gray" }
    }
    if ($null -ne $Message -and $Message.Length -gt 0)
    {
        $TimeStamp = [System.DateTime]::Now.ToString("yyyy-MM-dd HH:mm:ss")
        if ($null -ne $LogFile -and $LogFile -ne [System.String]::Empty)
        {
            Out-File -Append -FilePath $LogFile -InputObject "[$TimeStamp] $Message"
        }
        if ($ConsoleOutput -eq $true)
        {
            Write-Host "[$TimeStamp] [$LogLevel] :: $Message" -ForegroundColor $Color
        }
    }
}

Function cidr
{
    [CmdLetBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [Alias("Length")]
        [ValidateRange(0, 32)]
        $MaskLength
    )
    Process
    {
        Return LongToDotted ([Convert]::ToUInt32($(("1" * $MaskLength).PadRight(32, "0")), 2))
    }
}

Function LongToDotted
{
    [CmdLetBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [String]$IPAddress
    )
    Process
    {
        Switch -RegEx ($IPAddress)
        {
            "([01]{8}\.){3}[01]{8}" {
                Return [String]::Join('.', $($IPAddress.Split('.') | ForEach-Object { [Convert]::ToUInt32($_, 2) }))
            }
            "\d" {
                $IPAddress = [UInt32]$IPAddress
                $DottedIP = $(For ($i = 3; $i -gt -1; $i--)
                    {
                        $Remainder = $IPAddress % [Math]::Pow(256, $i)
                        ($IPAddress - $Remainder) / [Math]::Pow(256, $i)
                        $IPAddress = $Remainder
                    })
                Return [String]::Join('.', $DottedIP)
            }
            default
            {

            }
        }
    }
}

### End Function Declaration

# New-Alias appcmd.exe -Value $env:windir\System32\inetsrv\appcmd.exe

# Check if Elevated
$wid = [system.security.principal.windowsidentity]::GetCurrent()
$prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
$adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($prp.IsInRole($adm))
{
    Write-Log -LogFile $Logfile -LogLevel SUCCESS -ConsoleOutput -Message "Elevated PowerShell session detected. Continuing."
}
else
{
    Write-Log -LogFile $Logfile -LogLevel ERROR -ConsoleOutput -Message "This application/script must be run in an elevated PowerShell window. Please launch an elevated session and try again."
    Break
}

$IPs = Get-Content $Source
$count = $IPs.Count
$i = 1

# OnlyExportXML
If ($OnlyExportIPSecurityXML)
{
    foreach ($IP in $IPs)
    {
        If ($IP -match "/")
        {
            $CIDR = $IP.Split("/")[1]
            $IPAddr = $IP.Split("/")[0]
            $Mask = cidr $cidr
            $Content = "<add ipAddress=""$($IPAddr)"" subnetMask=""$($Mask)"" allowed=""true"" />"
            $Content | Out-File -Append $Output
            Write-Log -LogFile $Logfile -LogLevel INFO -Message "Network $IP processed."
        }
        Else
        {
            $Content = "<add ipAddress=""$($IPAddr)"" allowed=""true"" />"
            $Content | Out-File -Append $Output
            Write-Log -LogFile $Logfile -LogLevel INFO -Message "Address $IP processed."
        }
    }
    Write-Log -LogFile $Logfile -LogLevel SUCCESS -ConsoleOutput -Message "This XML output can be inserted under the <ipsecurity> node in the `$Windir\System32\Inetsrv\Config\applicationHost.config file for the appropriate web site."
    Write-Log -LogFile $Logfile -LogLevel SUCCESS -ConsoleOutput -Message "Path:"
    Write-Log -LogFile $Logfile -LogLevel SUCCESS -ConsoleOutput -Message "location path=Web Site Name/system.WebServer/Security/ipSecurity"
    Write-Log -LogFile $Logfile -LogLevel SUCCESS -ConsoleOutput -Message ""
    Write-Log -LogFile $Logfile -LogLevel SUCCESS -ConsoleOutput -Message "After inserting XML output into applicationHost.config file, restart IIS."
}

# Add Source IPs
If (!$OnlyExportIPSecurityXML)
{
    # Allow localhost
    add-webconfiguration /system.webServer/security/ipSecurity -location $Site -value @{ ipAddress = "localhost"; allowed = "true" } -pspath IIS:\

    foreach ($IP in $IPs)
    {
        Write-Host "Processing [$i / $count] :: $IP"
        try
        {
            If ($IP -match "/")
            {
                $CIDR = $IP.Split("/")[1]
                $IPAddr = $IP.Split("/")[0]
                $Mask = cidr $cidr
                #appcmd.exe set config "$Site" -section:system.webServer/security/ipSecurity /+"[ipAddress='$($IPAddr)',subnetmask='$($Mask)',allowed='True']" /commit:apphost

                add-webconfiguration /system.webServer/security/ipSecurity -location $Site -value @{ ipAddress = $IPAddr; subnetMask = $Mask; allowed = "true" } -pspath IIS:\ -ErrorAction stop
                Write-Log -LogFile $Logfile -LogLevel INFO -Message "Network $IP processed."
            }
            Else
            {
                #appcmd.exe set config $Site -section:system.webServer/security/ipSecurity /+"[ipAddress='$($IP)',allowed='True']" /commit:apphost

                add-webconfiguration /system.webServer/security/ipSecurity -location $Site -value @{ ipAddress = $IP; allowed = "true" } -pspath IIS:\ -erroraction stop
                Write-Log -LogFile $Logfile -LogLevel INFO -Message "Address $IP processed."
            }
        }
        catch
        {
            $Exception = $_.Exception
            $ErrorMessage = $_.Exception.Message
            Write-Log -Message "Error processing $IP" -LogFile $Logfile -LogLevel ERROR -ConsoleOutput
            Write-Log -Message $ErrorMessage -LogFile $Logfile -LogLevel ERROR
        }
        finally
        {
            $i++
        }
    }

    Try
    {
        Set-WebConfigurationProperty -Filter /system.webserver.ipsecurity -name allowUnlisted -value $false -Location $Site
        Write-Log -LogFile $Logfile -Message "Updated web configuration property to deny unlisted IP addresses to site $($Site)."
    }
    Catch
    {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Log -Message $ErrorMessage -LogFile $Logfile -LogLevel ERROR -ConsoleOutput
        Write-Log -Message $FailedItem -LogFile $Logfile -LogLevel ERROR -ConsoleOutput
    }
}