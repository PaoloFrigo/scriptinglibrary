#Paolo Frigo, https://scriptinglibrary.com

Function Backup-MyKeyVault {
 <#
    .SYNOPSIS
    Backup Azure Key Vault keys, certs and secrets

    .DESCRIPTION
    This funciton creates a ZIP archive containing all keys, secrets and certificates stored in your Azure Key Vault.

    .PARAMETER VaultName
    thi parameter is required to specify which Vault Name you want to backup

    .EXAMPLE
    Backup-MyKeyVault -KeyVault "mykeyvaultname1", "mykeyvaultname2"

    Specify one or more Azure Key Voults to backup

    .EXAMPLE
    get-azkeyvault | Backup-MyKeyVault
    Oneliner to enumerate all Azure Key Vault and create individual archive for each one.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName =$true)]
        [string[]]
        $VaultName
    )
    process {
        foreach ($MyVaultName in $VaultName) {

            if (($(Get-AzKeyVaultKey $MyVaultName).count +  $(Get-AzKeyVaultSecret $MyVaultName).count ) -gt 0)
            {
                #Creates temporary folders
                New-Item -ItemType Directory "$($MyVaultName)" | Out-Null
                Set-Location $MyVaultName
                New-Item -ItemType Directory -name "Certs"  | Out-Null
                New-Item -ItemType Directory -name "Secrets"  | Out-Null
                New-Item -ItemType Directory -name "Keys" | Out-Null

                #Stats counters
                $CertCounter=0
                $KeyCounter=0
                $SecretCounter=0

                Foreach ($item in $(Get-AzKeyVaultSecret -VaultName $MyVaultName)){
                    if ($item.ContentType -eq "application/x-pkcs12"){
                        $cert = Get-AzureKeyVaultCertificate -VaultName $MyVaultName -Name "$(($item).name)"
                        Backup-AzureKeyVaultCertificate -Certificate $cert -OutputFile "Certs\\$(($item).name).blob" -Force | Out-Null
                        $CertCounter+=1
                    }
                    else{
                        Backup-AzureKeyVaultSecret -VaultName $MyVaultName -Name $($item).name -OutputFile "Secrets\\$(($item).name).blob" | Out-Null
                        $SecretCounter+=1
                    }
                }
                Foreach ($keyitem in $(Get-AzKeyVaultKey -VaultName $MyVaultName)){
                    try{
                        Backup-AzKeyVaultKey -VaultName $MyVaultName -Name $($keyitem.name) -Output "Keys\\$($keyitem.name).blob" -ErrorAction SilentlyContinue |Out-Null
                        $KeyCounter+=1
                    }
                    catch {
                        Write-Error "$($keyitem.name) was not exported"
                    }
                }
                Set-Location ..
                $datetime = Get-Date -format "yyyyMMdd-hhmmss"
                $Filename = "$($MyVaultName)-$($datetime).zip"

                Compress-Archive -Path "$($MyVaultName)/*" -DestinationPath "$Filename"
                Remove-Item -Recurse -Force $MyVaultName
                Write-output "EXPORTED from `"$MyVaultName`" to `"$Filename`": `n $KeyCounter keys `n $CertCounter certificates `n $SecretCounter secrets "
            }
            else{
                Write-Output "NO ACTION for $($MyVaultName): `nThere are no Keys,Certificates or Secrets to backup!"
            }
        }
    }

}

#Backup all Azure Key Vaults
get-azkeyvault | Backup-MyKeyVault
