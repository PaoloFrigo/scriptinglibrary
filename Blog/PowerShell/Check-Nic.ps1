#Nagios/NSCP Network Interface Card Load Check
#Author: Paolo Frigo, https://www.scriptinglibrary.com
$NETWORK_CARD ="microsoft hyper-v network adapter*" 

$WARNING = 29
$CRITICAL = 49

$TransferRate = ((get-counter).countersamples  | where-object {$_.instancename -like "$NETWORK_CARD"} | select-object -exp CookedValue )*8

$NetworkUtilisation = [math]::round($TransferRate/1000000000*100,2)

if ($NetworkUtilisation -gt $CRITICAL){
	Write-Output "CRITICAL: $($NetworkUtilisation) % Network utilisation, $($TransferRate.ToString('N0')) b/s"   
	exit 2
}
if ($NetworkUtilisation -gt $WARNING){
	Write-Output "WARNING: $($NetworkUtilisation) % Network utilisation, $($TransferRate.ToString('N0')) b/s"
	exit 1
}
Write-Output "OK: $($NetworkUtilisation) % Network utilisation, $($TransferRate.ToString('N0')) b/s"   
exit 0

