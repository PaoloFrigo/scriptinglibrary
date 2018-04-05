. .\New-SubfolderWithDate

Describe "New-SubFolderWithDate Unit-Tests" -tags "unit-tests" {

    it "Should throw an error when the folder already exists" {
        Mock "Test-Path" {
            return $true
        }
        Mock "New-Item" {}
        {New-SubfolderWithDate -prefix "A"} | Should throw "Folder already exists"
    }
    it "Should throw an error when fails to create a folder" {
        Mock "Test-Path" {
            return $false
        }
        Mock "New-Item" {throw "any error"}
        {New-SubfolderWithDate -prefix "A"} | Should throw "Folder not created"
    }
}
Describe "New-SubFolderWithDate Integration-Tests" -tags "integration-tests" {
    it "Should create the folder" {
        $prefix = "ABCDEF123"
        $FolderName = "$prefix-$(Get-Date -Format "yyyyMMdd")"
        if ($(Test-Path $FolderName) -eq $false){
            New-SubfolderWithDate -prefix $prefix       
            Test-Path $FolderName
            Remove-Item $FolderName
        }
       else{
            Write-Output "Example folder already exists change prefix ABCDEF123"
       }
    }

}