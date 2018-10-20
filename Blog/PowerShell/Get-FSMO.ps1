# From Scripting Guys Blog
# https://blogs.technet.microsoft.com/heyscriptingguy/2014/11/28/powertip-use-powershell-to-get-list-of-fsmo-role-holders/
Get-ADDomain | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator
Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster
Get-ADDomainController -Filter * |
Select-Object Name, Domain, Forest, OperationMasterRoles |
Where-Object {$_.OperationMasterRoles} |
Format-Table -AutoSize