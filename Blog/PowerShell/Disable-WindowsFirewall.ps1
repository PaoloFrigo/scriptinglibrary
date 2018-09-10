#requires -runasadministrator
# Paolo Frigo, https://www.scriptinglibrary.com
#
# This script will disable the windows firewall for all profiles PUBLIC, DOMAIN, PRIVATE
#
Set-NetFirewallProfile -profile Public,domain,private -enabled false
# To check the FIREWALL PROFILE STATUS use
# Get-NetFirewallProfile | select-object name, enabled