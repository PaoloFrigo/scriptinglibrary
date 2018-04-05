function New-SubFolderWithDate {
    [cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [parameter(Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true)]
        [string]$Prefix
    )
    $FolderName = "$Prefix-$(Get-Date -Format "yyyyMMdd")" 
    if (Test-Path $FolderName){
        throw "Folder already exists"
    }
    try {
        New-Item -ItemType Directory -Name $FolderName
        Write-Verbose "Folder Created Successfully: $FolderName"
    }
    catch {
        throw "Folder not created"
    }    
}