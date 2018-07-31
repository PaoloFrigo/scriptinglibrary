# Paolo Frigo, 2018 
# https://www.scriptinglibrary.com

Function New-RandomPassword() {
    Param(
        [ValidateRange(8,32)] 
        [int] $length = 14
        )
    $AsciiCharsList = @()
    For ($a=33;$a –le 126;$a++) {
        $AsciiCharsList += ,[char][byte]$a 
    }    
    #RegEx for checking general AD Complex passwords
    $RegEx = "(?=^.{8,}$)(?=.*\d)(?=.*[!@#$%^&*]+)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"
    do {
        $Password=""
        For ($loop=1; $loop –le $length; $loop++) {
            $Password+=($AsciiCharsList | Get-Random)
        }
    }
    until ($Password -match $RegEx )   
    return $Password
}

Write-Output "Generate Random Password: $(New-RandomPassword(10))"
