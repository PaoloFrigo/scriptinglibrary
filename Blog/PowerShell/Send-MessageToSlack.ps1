#requires -module ActiveDirectory

#Paolo Frigo, https://www.scriptinglibrary.com

# The execution of this is scheduled to run every 5 minutes on ServerX

# The goal of this script to notify to SLACK Channel: "#GENERAL" channel
# every single lockout-event in the local AD domain.

# Webhooks Channel
$SlackChannelUri = "https://hooks.slack.com/services/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"
$ChannelName = "#general"

$BodyTemplate = @"
    {
        "channel": "CHANNELNAME", 
        "username": "AD-Mominitor", 
        "text": "DOMAIN_USERNAME account is currently locked out. DATETIME.", 
        "icon_emoji":":ghost:" 
    }
"@


if (Search-ADAccount -LockedOut){
    foreach ($user in (Search-ADAccount -LockedOut)){
        $body = $BodyTemplate.Replace("DOMAIN_USERNAME","$user").Replace("DATETIME",$(Get-Date)).Replace("CHANNELNAME","$ChannelName")
        Invoke-RestMethod -uri $SlackChannelUri -Method Post -body $body -ContentType 'application/json'
    }
}