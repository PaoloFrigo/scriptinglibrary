#requires -module Az

#Paolo Frigo, https://www.scriptinglibrary.com

#Connect to your Azure account
Connect-AzAccount

#List all available Vaults
Get-AzKeyVault
#In case of multiple Vaults Use Tags or Name to filter the right one.

# Get the Access Policies/Network Rules etc for your Vault
# e.g. azkeyvscriptinglibXXXXX
Get-AzKeyVault azkeyvscriptinglibXXXXX

# Add a secret to the Vault
$MySecret = Get-Credential 
Set-AzKeyVaultSecret -VaultName azkeyvscriptinglibXXXXX -name $Mysecret.username -SecretValue $Mysecret.password

# Retrieve a secret from the Vault in a SecureString Format
(Get-AzKeyVaultSecret -VaultName azkeyvscriptinglibXXXXX -Name $Mysecret.username).SecretValue
# Retrieve a secret from the Vault into a Plain Text Format
(Get-AzKeyVaultSecret -VaultName azkeyvscriptinglibXXXXX -Name $Mysecret.username).SecretValueText

#Disconnect-AzAccount or Logout-AzAccount