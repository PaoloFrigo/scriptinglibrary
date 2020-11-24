
# Paolo Frigo, https://www.scriptinglibrary.com

#  CONNECT TO AZURE CLOUD SHELL HTTPS://SHELL.AZURE.COM

# CONENCT TO AZURE AD
connect-azuread

# CHECK THE DETAILS OF YOUR AAD TENANT
# Get-AzureADTenantDetail -All $true

# GET THE AAD SECURITY GROUPS OF YOUR USERS 
# Replace the 2 UserPrincipalName of your e.g.  john.doe@contoso.com
$USERS = "UPN_OF_USER_A", "UPN_OF_USER_B"

foreach ($User in $Users){
	Get-AzureADUser -ObjectId $user
	Get-AzureADUser -ObjectId $User | Get-AzureADUserMembership | Select-Object -ExpandProperty displayname
}


# OR USE THIS ONELINER TO COMPARE THE SECURITY GROUPS OF 2 AAD USERS
Compare-object $(Get-AzureADUser -ObjectId "UPN_OF_USER_A" | Get-AzureADUserMembership | Select-Object  -exp displayname) $(Get-AzureADUser -ObjectId "UPN_OF_USER_B"| Get-AzureADUserMembership | Select-Object  -exp displayname)
