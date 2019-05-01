#requires -runasdministrator

#Paolo, scriptinglibrary.com

#Get-Help about_signing  #Official doc

$MySigningCertificate = New-SelfSignedCertificate -subject "Paolo's Signing Certificate" -Type CodeSigning -CertStoreLocation "cert:\LocalMachine\My"

#Export our pfx and use a strong password to protect it
#Never store a password in your script!
$MyStrongPassword = ConvertTo-SecureString -String "SuperSecret!" -Force -AsPlainText
$PathWhereToSaveIt = "D:\MyNewSigningCertificate.pfx"
$MySigningCertificate | Export-PfxCertificate -FilePath $PathWhereToSaveIt -password $MyStrongPassword


#How to import it
#Personal
Import-PfxCertificate -FilePath $PathWhereToSaveIt -CertStoreLocation "cert:\LocalMachine\My" -Password $MyStrongPassword
#TrustedPublisher
Import-PfxCertificate -FilePath $PathWhereToSaveIt -CertStoreLocation "cert:\LocalMachine\Root" -Password $MyStrongPassword
#Root
Import-PfxCertificate -FilePath $PathWhereToSaveIt -CertStoreLocation "cert:\LocalMachine\TrustedPublisher" -Password $MyStrongPassword

#List Certificate
Get-ChildItem "Cert:\LocalMachine\My\" -CodeSigningCert
# My Signing Cert
$MyCert = (Get-ChildItem "Cert:\LocalMachine\My\" -CodeSigningCert)[0]
#List all the details
Get-ChildItem Cert:\LocalMachine\My\ -CodeSigningCert | Select-Object *

$TestDir = "D:\TestFolder"
#Create new directory
New-Item -ItemType "Directory" -Path $TestDir
#Create few scripts and sign them
1..5| ForEach-Object {Set-Content -path "$testdir\ExampleScript$_.ps1" -Value "Get-ChildItem"}
#List Contet
Get-ChildItem $TestDir

#Signing multiple scripts at once
$MyCertFromPfx = Get-PfxCertificate -FilePath $PathWhereToSaveIt #Will Be Prompted for the password
#Sign all files
Get-ChildItem $TestDir | Set-AuthenticodeSignature -certificate $MyCertFromPfx -IncludeChain "All"
#Check all files
Get-ChildItem $TestDir| Get-AuthenticodeSignature