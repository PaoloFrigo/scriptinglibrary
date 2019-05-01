# Paolo Frigo, 2018
# https://www.scriptinglibrary.com

. .\New-RandomPassword.ps1

Describe "New-RandomPassword" -Tags "Unit Tests" {
    it "Should generate a String" {
        (New-RandomPassword).GetType().Name | Should BeExactly "String"
    }

    #Pick a password Length between 0 and 7 and 33 and 100 characters
    $n = 0..1 + 33..100
    foreach ($length in $n){
        it "Should throw an exeption if the password Length ($length) is out of the accepted range (8-32)"    {
            {New-RandomPassword -Length 5} | Should throw
        }
    }
    #Pick a password Length between 8 and 32 characters
    $n = 8..32
    foreach ($length in $n){
        It "Should generate a password $length character long" {
            (New-RandomPassword($length)).length | Should BeExactly "$length"
        }
    }
    #Test/Generate 300 passwords
    foreach ($attempt in (1..300)){
        It "Should generate a password complex enough for AD ($attempt/300 attempt)"{
            $n = 8..32 | Get-Random
            $RegEx = "(?=^.{8,32}$)((?=.*\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*"
            (New-RandomPassword($n)) -match $RegEx
        }
    }
}
