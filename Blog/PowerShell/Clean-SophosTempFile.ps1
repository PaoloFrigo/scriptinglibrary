#Paolo Frigo, https://www.scriptinglibrary.com

# Removes temporary files from Sophos Temp folder

$SophosTempDir = "C:\Windows\Temp\" #"C:\ProgramData\Sophos\Sophos Anti-Virus\Temp\"

if (test-path $SophosTempDir){
    $SophosTempFiles= Get-childitem "$($SophosTempDir)*`$`$`$"
    if ($SophosTempFiles){
        try {
            $SophosTempFiles | Remove-Item -Force
            Write-OutPut "$($($SophosTempFiles).count) files removed from $SophosTempDir"
        }
        catch{
            Write-Error "Clean-up operation failed."
            exit 1
        }        
    }
}
else {
    Write-Error "The Sophos directory doesn't exist $SophosTempDir"
}
exit 0 