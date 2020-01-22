#requires -module activedirectory

. .\Get-LockedOutInfo.ps1

# Paolo Frigo, https://www.scriptinglibrary.com

#Webhooks channel
$TeamsChannelUri = "PASTE_YOUR_TEAMS_URL"

$BodyTemplate = @"
    {
        "@type": "MessageCard",
        "@context": "https://schema.org/extensions",
        "summary": "ADUserLockOut-Notification",
        "themeColor": "D778D7",
        "title": "Active Directory: FULLNAME Account Locked-Out",
        "sections": [
            {
           
                "facts": [
                    {
                        "name": "Username:",
                        "value": "DOMAIN_USERNAME"
                    },                  
                    {
                        "name": "From Server/ Computer:",
                        "value": "CALLERID"
                    },                
                    {
                        "name": "LockoutTime Time:",
                        "value": "LOCKOUTTIME"
                    },
             {
                        "name": "Notification Time:",
                        "value": "DATETIME"
                    },
           {
                        "name": "Domain Controller:",
                        "value": "DC"
                    },
                ],
                "text": "An AD account is currently being locked out for 15 minutes"
            }
        ]
    }
"@

if (Search-ADAccount -LockedOut){
    foreach ($user in (Search-ADAccount -LockedOut)){
        $Event = get-lockedoutInfo -username $($user.samaccountname) -justPdc $false
        $body = $BodyTemplate.Replace("DOMAIN_USERNAME",$($user.samaccountname)).Replace("FULLNAME",$user.name).Replace("DATETIME",$(Get-Date)).Replace("CALLERID", $Event.callerid).Replace("DC", $Event.DC).Replace("LOCKOUTTIME", $Event.Time)    
        Invoke-RestMethod -uri $TeamsChannelUri -Method Post -body $body -ContentType 'application/json'        
    }
}
exit 0
