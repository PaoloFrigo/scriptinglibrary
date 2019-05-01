#
#   Paolo Frigo, www.scriptinglibrary.com
#
$header="".ToUpper()
$footer=" This message will close automatically in $TimeOut seconds.".ToUpper()
$NameList = ""
$TimeOut = 15 #seconds

$LockedOutUsersList = Search-ADAccount -LockedOut | Where-Object {$_.enabled -eq $true}

if ($LockedOutUsersList.Length -gt 0){
    foreach ($AdUser in $LockedOutUsersList){
        $NameList += "$AdUser, "
    }
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup($header+$NameList+$footer,$TimeOut,"AD USERS LOCKED OUT",0)
}
exit 0