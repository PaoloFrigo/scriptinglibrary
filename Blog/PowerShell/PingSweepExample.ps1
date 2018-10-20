#Paolo Frigo, scriptinglibrary.com
#Ping Sweep
(1..254) | % {$ip="10.0.40.$_"; Write-output "$IP  $(test-connection -computername "$ip" -quiet -count 1)"}