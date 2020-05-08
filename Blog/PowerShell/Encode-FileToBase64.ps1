#Paolo Frigo, https://www.scriptinglibrary.com

#This helper function will encode a file into a Base64 string
function Encode-FileToBase64{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [string]
        $filename
    )
    if (Test-Path "$filename"){
        $content = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllText("$fileName")))
        return $filename, $content
    }
    throw "File not found $fileName"
}

#Example
get-childitem | export-csv example.csv    
Encode-FileToBase64 example.csv         

