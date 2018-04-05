#requires -runasadministrator
. .\lib\New-SubFolderWithDate.ps1

$ConfigFile = "config\DeploymentConfig.json"

if ($(Test-Path $ConfigFile) -eq $false){
    throw "Missing config file: $($ConfigFile)"
}

$config = Get-Content $ConfigFile | ConvertFrom-Json
 
Write-Output "[$($config.environment.type)] $($config.project.name) - Version: $($config.info.version)"

if ($config.environment.type -eq "TEST"){
    New-SubFolderWithDate -prefix $config.environment.type -verbose
}

foreach ($artefact in $config.artefacts){
    try{
        Invoke-WebRequest -uri $artefact.uri -UseBasicParsing -out "lib\$($artefact.filename)" -TimeoutSec 30
        Write-Output "Artefact Downloaded : $($artefact.description)"
    }
    catch {
        throw "Artifact Download Error"
    }
}