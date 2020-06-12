​#Requires -RunAsAdministrator 
#Paolo Frigo, https://www.scriptinglibrary.com

# SETTINGS EMAIL REPORT 
$MailRecipient = "Recipient Name <email@address.com>"
$MailSender = "Sender Name <email@address.com>"
$MailServer = "mail.server.com"
$TargetServers = (Get-ADComputer -Filter * | Where-Object {$_.name -like "server-*"  }).Name

$ServerList = @{}
#CHECK SERVER REBOOT TIME
foreach ($Server in $TargetServers ) {
    Try {
        $BootUpTime = (Get-CimInstance -ClassName win32_operatingsystem -ComputerName "$Server" ).LastBootUpTime
    }
    Catch {
        $BootUpTime = "N/A"
    }
    $ServerList.Add($Server, $BootUpTime)
}
#GENERATE EMAIL REPORT
Send-MailMessage -To "$MailRecipient" -From "$MailSender" -Subject "Reboot time of target servers" -Body "$($ServerList|Out-String)" -SmtpServer "$MailServer"
exit 0 