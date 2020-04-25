#Paolo Frigo, https://www.scriptinglibrary.com

#This helper function will encode a file into a Base64 string
function Encode-FileToBase64($filename){
    if (Test-Path "$filename"){
        $content = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($(get-content $fileName)))
        return $filename, $content
    }
    throw "File not found $fileName"
}

#EX
ls > example.txt   
Encode-FileToBase64 example.txt

