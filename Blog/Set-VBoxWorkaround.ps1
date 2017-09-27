#
#   Paolo Frigo, www.scriptinglibrary.com
#
get-service vbox* | stop-service
Set-Date -Date (Get-Date).AddDays(-60)
get-service  -Exclude vbox* | Where-Object {$_.status -eq "stopped" -and $_.StartType -eq "automatic"} | start-service
get-service vbox* | start-service