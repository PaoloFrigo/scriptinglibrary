
#Paolo Frigo, ScriptingLibrary.com
#Reverse Lookup
(1..254) | ForEach-Object {$ip="10.0.40.$_"; Write-output "$IP  $( Resolve-DnsName $ip -ErrorAction Ignore |Select-Object -exp NameHost )  "}