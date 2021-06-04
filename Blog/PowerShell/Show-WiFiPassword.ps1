#Paolo Frigo, https://scriptinglibrary.com

# This script print all WiFi setting stored in the your system
# SSID : passphrase

# .Notes
# This script is a wrapper of this 2 netsh commands
# netsh.exe wlan show profiles                              #Shows all your wifi
# netsh.exe wlan show profiles name="$SSID" key=clear       #Shows the passphrase stored for SSID wifi network in the Key Content value.

$wifi = $(netsh.exe wlan show profiles)

if ($wifi -match "There is no wireless interface on the system."){
	Write-Output $wifi
	exit
}

$ListOfSSID = ($wifi | Select-string -pattern "\w*All User Profile.*: (.*)" -allmatches).Matches | ForEach-Object {$_.Groups[1].Value}
$NumberOfWifi = $ListOfSSID.count
Write-Warning "[$(Get-Date)] I've found $NumberOfWifi Wi-Fi Connection settings stored in your system $($env:computername) : "
foreach ($SSID in $ListOfSSID){
    try {
        $passphrase = ($(netsh.exe wlan show profiles name=`"$SSID`" key=clear) |
                    Select-String -pattern ".*Key Content.*:(.*)" -allmatches).Matches |
                        ForEach-Object {$_.Groups[1].Value}
    }
    catch {
        $passphrase = "N/A"
    }
    Write-Output "$SSID : $passphrase"
}