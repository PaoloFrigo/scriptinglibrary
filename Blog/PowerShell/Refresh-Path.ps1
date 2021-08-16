# PF, https://scriptinlibrary.com

# https://stackoverflow.com/questions/17794507/powershell-reload-the-path-in-powershell
function Refresh-PathEnv {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
    Write-Output "Environment Variable Refreshed"
}
