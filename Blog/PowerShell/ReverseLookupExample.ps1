
#Paolo Frigo, ScriptingLibrary.com
#Reverse Lookup
(1..254) | % {$ip="10.0.40.$_"; Write-output "$IP  $( Resolve-DnsName $ip -ErrorAction Ignore |select -exp NameHost )  "}    