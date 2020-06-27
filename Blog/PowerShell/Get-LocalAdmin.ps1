function Get-LocalAdmin {

    <#

        .Synopsis
            Get Local admin list
        .Description
            Get Local admin list

        .Example
            Get-LocalAdmin  -Computername myworkstation.contoso.com

            This shows the NTP Status of the localhost, this will be the result:

            Retrieving Local Admin list for myworkstation.contoso.com
            MYWORKSTATION\Administrator
            CONTOSO\Domain Admins

        .Example
             get-adcomputer -searchbase ‘OU=workstations,dc=contoso,dc=com’ -filter * -property * | select name  | Get-LocalAdmin

             Get Local admin list for all the workstation in AD.

        .Notes
              Author: Paolo Frigo  https://www.scriptinglibrary.com

 #>
    param (

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [Alias('Name')]

        [string[]]$ComputerName
    )
    Process {

        Write-Warning "Retrieving Local Admin list for $ComputerName"

        try {
            If (!(Test-Connection -ComputerName $computerName -Count 1 -Quiet)) {
                Write-Output "$computerName is offline."
                #Continue # Move to next computer
            }
            else {
                $admins = Get-WmiObject win32_groupuser –computer $ComputerName
                $admins = $admins |Where-Object {$_.groupcomponent –like '*"Administrators"'}
                $admins | ForEach-Object {
                    $_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul
                    $matches[1].trim('"') + “\” + $matches[2].trim('"')  }
            }

        }
        catch {
            Write-Output "Can't gather information from $ComputerName"
            Write-Output $Error[0].Exception;
        }
        finally {

        }

    }
}


#Example with desktop, but you can use Laptops or VMs or Servers as OU
get-adcomputer -searchbase ‘OU=workstations,dc=contoso,dc=com’ -filter
