#Paolo Frigo, https://scriptinglibrary.com

<#
    .SYNOPSIS
    Add a file to a blob storage

    .DESCRIPTION
    This function leverages the Azure Rest API to upload a file into a blob storage using a SAS token.

    .PARAMETER file
    Absolute path of the file to upload

    .PARAMETER connectionstring
    Uri and SAS token

    .EXAMPLE
    Add-FileToBlogStorage -file "FULL_PATH" -connectionstring "BLOBSTORAGE_URI_WITH_SAS_TOKEN"

#>
function Add-FileToBlobStorage{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_ })]
        [string]
        $file,
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -match "https\:\/\/(.)*\.blob.core.windows.net\/(.)*\?(.)*"})]
        [string]
        $connectionstring
    )
    $HashArguments = @{
        uri = $connectionstring.replace("?","/$($(get-item $file).name)?")
        method = "Put"
        InFile = $file
        headers = @{"x-ms-blob-type" = "BlockBlob"}

    }
    Invoke-RestMethod @HashArguments
}