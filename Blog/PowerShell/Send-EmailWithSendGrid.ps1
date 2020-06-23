#Paolo Frigo, https://www.scriptinglibrary.com


<#
.Synopsis
    This function sends an email using SendGrid APIs

.DESCRIPTION
    This function sends an email using SendGrid REST API. 

.EXAMPLE
   Send-EMailWithSendGrid -from "email@domain" -to "email@domain" -ApiKey "MY_SENDGRID_API_KEY" -Body "Test 1..2..3!" -Subject "Sendgrid Test"

.NOTES
   Author Paolo Frigo,  https://www.scriptinglibrary.com
#>
function Send-EmailWithSendGrid {
     Param
    (
        [Parameter(Mandatory=$true)]
        [string] $From,
 
        [Parameter(Mandatory=$true)]
        [String] $To,

        [Parameter(Mandatory=$false)]
        [String] $Cc,

        [Parameter(Mandatory=$false)]
        [String] $Bcc,

        [Parameter(Mandatory=$true)]
        [string] $ApiKey,

        [Parameter(Mandatory=$true)]
        [string] $Subject,

        [Parameter(Mandatory=$true)]
        [string] $Body

    )

    $headers = @{}
    $headers.Add("Authorization","Bearer $apiKey")
    $headers.Add("Content-Type", "application/json")

    $jsonRequest = [ordered]@{
                            personalizations= @(
                                @{
                                    to = @(@{email =  "$To"}
                                )
                                   subject = "$SubJect" }
                                )
                                from = @{email = "$From"}
                                content = @( @{ type = "text/plain"
                                            value = "$Body" })
                            } | ConvertTo-Json -Depth 10

    Invoke-RestMethod   -Uri "https://api.sendgrid.com/v3/mail/send" -Method Post -Headers $headers -Body $jsonRequest 

}

# $From = "email@address"
# $To = "email@address"
# $APIKEY = "MY_API_KEY"
# $Subject = "TEST"
# $Body ="SENDGRID 123"

# Send-EMailWithSendGrid -from $from -to $to -ApiKey $APIKEY -Body $Body -Subject $Subject