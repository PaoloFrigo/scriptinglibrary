#requires -module ActiveDirectory

#Paolo Frigo, https://www.scriptinglibrary.com

# The execution of this is scheduled to run every 5 minutes on ServerX

# The goal of this script to notify to SLACK Channel: "#GENERAL" channel
# every single lockout-event in the local AD domain.

# Webhooks Channel
$SlackChannelUri = "https://hooks.slack.com/services/ETC..ETC.."
$ChannelName = "#general"

$BodyTemplate = @"
    {
        "channel": "CHANNELNAME",
        "username": "ActiveDirectory Bot",
        "text": "*DOMAIN_USERNAME* account is currently locked out. \nTime: DATETIME.",
        "icon_emoji":":ghost:"
    }
"@


if (Search-ADAccount -LockedOut){
    foreach ($user in (Search-ADAccount -LockedOut)){
        $body = $BodyTemplate.Replace("DOMAIN_USERNAME","$user").Replace("DATETIME",$(Get-Date)).Replace("CHANNELNAME","$ChannelName")
        Invoke-RestMethod -uri $SlackChannelUri -Method Post -body $bodytemplate -ContentType 'application/json'
    }
}
