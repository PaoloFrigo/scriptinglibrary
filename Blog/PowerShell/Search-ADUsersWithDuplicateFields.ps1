#Requires -Module ActiveDirectory
#Paolo Frigo, https://www.scriptinglibrary.com

# THIS SCRIPT CAN BE USE TO SEARCH FOR AD USERS WITH THE SAME EMAIL ADDRESS, EMPLOYEEID, ETC...

$OU="OU=External,OU=Staff,DC=contoso,DC=com" #Limit the scope to your OU
$DuplicateField = "mail" #choose what is the duplicate field you are searching

Get-ADUser -SearchBase $OU -properties $DuplicateField  -filter * | Group-Object $DuplicateField | Where-Object {$_.count -gt 1}