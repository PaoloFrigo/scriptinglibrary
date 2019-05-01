#requires -module activedirectory

# This script requires a rdg.xml template and generates an rdg file for
# RDMan - Remote Desktop Connection Manager

#Paolo Frigo, https://www.scriptinglibrary.com

#$ComputerListFromAD = get-adcomputer -Filter * -Properties *

#Generating a list of fake servers from server1 to server100 instead of querying AD
$ComputerListFromAD = 1..100 | ForEach-Object {write-output "Server$_"}

$RDGTemplate = $PSScriptRoot + "\"+ "rdg.xml"
$RDGFileOutPut =  $PSScriptRoot + "\" +"scriptinglibrary.rdg"

[XML] $template = Get-Content $RDGTemplate

$template.RDCMan.file.group

foreach ($pc in $ComputerListFromAD) {
    $s = $template.CreateNode("element", "server","")
    $p = $template.CreateNode("element", "properties","")
    $n = $template.CreateNode("element", "name","")
    $n.set_InnerXML($pc)
    $template.RDCMan.file.group.AppendChild($s).AppendChild($p).AppendChild($n)
}

$template.save($RDGFileOutPut)
Write-Output "RDG File generated: $RDGFileOutPut"