#requires -module ActiveDirectory

#Paolo Frigo, https://www.scriptinglibrary.com

# The execution of this is scheduled to run every 5 minutes on ServerX

# The goal of this script to notify to Teams Channel: "Test Area for Webhooks" channel
# every single lockout-event in the local AD domain.

#Test Webhooks Channel
$TeamsChannelUri = "https://outlook.office.com/webhook/THE_REST_OF_THE_URI_HAS_BEEN_REMOVED"

$BodyTemplate = @"
    {
        "@type": "MessageCard",
        "@context": "https://schema.org/extensions",
        "summary": "ADUserLockOut-Notification",
        "themeColor": "D778D7",
        "title": "Active Directory: Account Locked-Out Event",
         "sections": [
            {

                "facts": [
                    {
                        "name": "Username:",
                        "value": "DOMAIN_USERNAME"
                    },
                    {
                        "name": "Time:",
                        "value": "DATETIME"
                    }
                ],
                "text": "An AD account is currently being locked out for 15 minutes"
            }
        ]
    }
"@


if (Search-ADAccount -LockedOut){
    foreach ($user in (Search-ADAccount -LockedOut)){
        $body = $BodyTemplate.Replace("DOMAIN_USERNAME","$user").Replace("DATETIME",$(Get-Date))
        Invoke-RestMethod -uri $TeamsChannelUri -Method Post -body $body -ContentType 'application/json'
    }
}