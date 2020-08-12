#requires -runasadministrator

# Paolo Frigo, https://www.scriptinglibrary.com
# This oneliner adds an inbound rule for allowing Ping (ICMP protocol on IPv4)

New-NetFirewallRule –DisplayName “Allow Ping / ICMP” –Protocol ICMPv4