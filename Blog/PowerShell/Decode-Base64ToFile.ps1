#Paolo Frigo, https://www.scriptinglibrary.com

#This helper function will dencode a base64 string into a file
function Decode-Base64ToFile{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [string] 
        $outputfile,
        [Parameter(Mandatory=$True)]
        [string] 
        $base64string
    )
    [System.IO.File]::WriteAllText($outputfile, [System.Text.Encoding]::Utf8.GetString([System.Convert]::FromBase64String($base64string)))
    Write-Output "$($outputfile) created"
}

#[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllText("hello.txt")))

#Hello, World! 
$base64 = "SGVsbG8sIFdvbHJkIQ0K"
$outputfile = "hello.txt"

Decode-Base64ToFile -outputfile $outputfile -base64string $base64
