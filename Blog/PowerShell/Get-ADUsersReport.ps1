#requires -module ActiveDirectory

# This scripts generates a generic report on user access and status in a csv format

#Paolo Frigo, https://www.scriptinglibrary.com

#SETTINGS
$Domain = "YOUR_DOMAIN"
$BaseOU = "OU"
$CSVReport = "UsersReport.csv"

#https://docs.microsoft.com/en-us/archive/blogs/askds/the-lastlogontimestamp-attribute-what-it-was-designed-for-and-how-it-works
$PrimaryDC = Get-ADDomainController -Discover -Domain $domain -Service "PrimaryDC"
$MaxPswAge = (Get-ADDefaultDomainPasswordPolicy).MaxPAsswordAge.Days

Get-aduser -filter * -SearchBase $BaseOU -properties * -server $PrimaryDC | Select-Object name, samaccountname, emailaddress,enabled,created, passwordLastSet, @{Name="Password Expires"; Expression={($.passwordLastSet).addDays($MaxPswAge)}}, passwordexpired, lastlogondate, @{Name="Account Expires"; Expression={[DateTime]::FromFileTime($_.accountexpires)}} |Export-Csv -Path $CSVReport -NoTypeInformation
Write-Output "CSV Report Generated: $CSVReport"