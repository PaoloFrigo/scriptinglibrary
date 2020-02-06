#Nagios/NSCP Network Interface Card Load Check
#Author: Paolo Frigo, https://www.scriptinglibrary.com

$NETWORK_CARD ="microsoft hyper-v network adapter*" 
$WARNING = 29
$CRITICAL = 49

$NetworkUtilisation = [math]::round(((get-counter).countersamples  | where-object {$_.instancename -like "$NETWORK_CARD"} | select-object -exp CookedValue )*8/(1024*1024),2)

if ($NetworkUtilisation -gt $CRITICAL){
	Write-Output "CRITICAL: $($NetworkUtilisation) % Network utilisation"   
	exit 2
}
if ($NetworkUtilisation -gt $WARNING){
	Write-Output "WARNING: $($NetworkUtilisation) % Network utilisation"   
	exit 1
}

Write-Output "OK: $($NetworkUtilisation) % Network utilisation"   
exit 0