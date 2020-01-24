#Requires -module ActiveDirectory

# Paolo Frigo, https://www.scriptinglibrary.com

function Get-LockedOutInfo
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([Hashtable])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $username,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        $justPDC


    )

    Begin
    {
    }
    Process
    {
       
        $DClist = (Get-ADDomainController -Filter * )
       
        if ($justPDC){            
             $DClist = $DClist | Where-Object { $_.OperationMasterRoles -contains "PDCEmulator" }
        }        
        $results = (@())
        foreach ($addc in ($DClist| Select-Object -ExpandProperty hostname)){          
           
            if (Test-Connection -Quiet -count 1 -ComputerName $addc){
                $LockoutEvents = Get-WinEvent -ComputerName $addc -FilterHashtable @{Logname="Security";ID=4740} -ErrorAction SilentlyContinue
                if ($LockoutEvents){
                    $time = $LockoutEvents[0].TimeCreated
                    $details = $LockoutEvents[0].message            
                    if ($details -match $username -and $details -match  "Caller Computer Name:\s([a-zA-Z\-0-9]*)"){
                        $results +=( @{
                            'Username' = $username;
                            'callerid' =  $Matches[1];
                            'Time' = $time;
                            'DC'="$addc"
                        })
                           
                    }
                }
            }
            else {
                Write-Warning "$addc not reachable"
            }            
        }
        return $results
    }
    End
    {
    }
}



#Example
#Get-LockedOutInfo -username $username -justPDC $true