#Paolo Frigo, https://www.scriptinglibrary.com

#doc
#https://docs.microsoft.com/en-us/powershell/module/exchange/mailboxes/search-mailbox?view=exchange-ps


$admin = "paolofrigo"
$query = "from:attacker@domain.com" #", subject:, content:"  #"KEYWORD OR KEYWORD"



#load the Exchange management shell SnapIn
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

#Check if your user is a member of these groups
#Get-RoleGroupMember "Discovery Management" 
#Get-RoleGroupMember "Organization Management"

Get-Mailbox -ResultSize unlimited | Search-Mailbox -SearchQuery "$query" -TargetMailbox $admin -TargetFolder "SearchAndDeleteLog" -LogOnly -LogLevel Full


#Searh Mailbox is being deprecated consider to user New-ComplianceSearch
#https://docs.microsoft.com/en-us/powershell/module/exchange/policy-and-compliance-content-search/new-compliancesearch?view=exchange-ps

#https://www.scriptinglibrary.com/languages/powershell/removing-a-phishing-email-from-all-exchange-mailboxes-with-powershell//