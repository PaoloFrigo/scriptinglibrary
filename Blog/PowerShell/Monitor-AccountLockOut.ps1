#requires -module BurntToast,ActiveDirectory

#Paolo Frigo, https://www.scriptinglibrary.com

$SleepTime = 60 #seconds
do {
    if (Search-ADAccount -LockedOut) {
        foreach ($user in (Search-ADAccount -LockedOut)) {
            New-Burnttoastnotification -text "Locked-Out User Notification", "$($($user).name) is now Locked-Out"
        }
    }
    start-sleep -Seconds $SleepTime
}
while ($True)


<#
 # If you want a limited number of test you can use a foreach loop instead of a do-while
 #
ForEach ($i in (1..100)){
    if (Search-ADAccount -LockedOut) {
        foreach ($user in (Search-ADAccount -LockedOut)) {
            New-Burnttoastnotification -text "Locked-Out User Notification", "$($($user).name) is now Locked-Out"
        }
    }
    start-sleep -Seconds $SleepTime
}
#>

 # A better approach can be simple schedule this job and run it any minute.
