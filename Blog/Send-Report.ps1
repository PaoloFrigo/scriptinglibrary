​#-Requires RunAsAdministrator


# Email configuration details
$MailRecipient = "Recipient Name <email@address.com>"
$MailSender = "Sender Name <email@address.com>"
$MailServer = "mail.server.com"
$TargetServers = (Get-ADComputer -Filter * | Where-Object {$_.name -like "server-*"  }).Name

$ServerTable = @{}
#Check Server Reboot Time
foreach ($Server in $TargetServers ) {
    Try {
        $BootUpTime = (Get-CimInstance -ClassName win32_operatingsystem -ComputerName "$Server" ).LastBootUpTime
    }
    Catch {
        $BootUpTime = "N/A"
    }
    $ServerTable.Add($Server, $BootUpTime)
}
#Generate Email Report
Send-MailMessage -To "$MailRecipient" -From "$MailSender" -Subject "Reboot time of target servers" -Body "$($ServerTable|Out-String)" -SmtpServer "$MailServer"
exit 0