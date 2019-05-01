#Paolo Frigo, scriptinglibrary.com
#Ping Sweep
(1..254) | ForEach-Object {$ip="10.0.40.$_"; Write-output "$IP  $(test-connection -computername "$ip" -quiet -count 1)"}