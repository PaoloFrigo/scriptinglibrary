#Paolo Frigo, ScriptingLibrary.com
#Ping sweep and reverse lookup together
(1..254) | ForEach-Object {$ip="10.0.40.$_"; Write-output "$IP  $(test-connection -computername "$ip" -quiet -count 1)  $( Resolve-DnsName $ip -ErrorAction Ignore |Select-Object -exp NameHost )  "}
