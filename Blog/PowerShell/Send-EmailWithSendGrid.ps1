function Send-MailMessageWithSendGrid {
     Param
    (
       
        [Parameter(Mandatory=$true)]
        [string] $From,
 
        [Parameter(Mandatory=$true)]
        [String] $To,

        [Parameter(Mandatory=$true)]
        [string] $ApiKey,

        [Parameter(Mandatory=$true)]
        [string] $Subject,

        [Parameter(Mandatory=$true)]
        [string] $Body

    )

    $headers = @{}
    $headers.Add("Authorization","Bearer $($apiKey)")
    $headers.Add("Content-Type", "application/json")

    $jsonRequest = [ordered]@{
       personalizations= @(@{to = @(@{email =  "$To"})
                                      subject = "$SubJect" })
                  from = @{email = "$From"}
               content = @(  @{ type = "text/plain"
                value ="$Body" }
      )} | ConvertTo-Json -Depth 10

    Invoke-RestMethod   -Uri "https://api.sendgrid.com/v3/mail/send" -Method Post -Headers $headers -Body $jsonRequest
}




$From = "email@address"
$To = "email@address"
$APIKEY = "MY_API_KEY"
$Subject = "TEST"
$Body ="SENDGRID 123"

Send-MailMessageWithSendGrid -from $from -to $to -ApiKey $APIKEY -Body $Body -Subject $Subject