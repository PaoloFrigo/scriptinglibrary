#requires -runasadministrator

#Paolo Frigo, https://www.scriptinglibrary.com

#add the veeam snapin
Add-PSSnapin VeeamPSSnapIn

#check all the availabe cmdlets
Get-Command -module veeampssnapin

#connect to a veeam backup server
Connect-VBRServer

#get the details user, server, port of the opened connections
Get-VBRServerSession

#get a list of all Servers MS HYPER-V and or VMWare-vSphere
Get-VBRServer

#Find the VM on WMWARE
Find-VBRViEntity

#Find the VM on Hyper-V
Find-VBRHvEntity

#Get the VBR Credentials
Get-VBRCredentials

#Let's use this example

$hyperv_node = "hyper-lab.contoso.com" # or a list of nodes
$vm_name = "testd-web01"
$vm=Find-VBRHvEntity -server $hyperv_node -name $vm_name
$nas="\\nas.contoso.com\Archive"
$vmm_cred = Get-VBRCredentials | Where-Object {$_.description -like "scvmm"}
$email_notify_to= "me@contoso.com"
$email_notify_from = "veeam-bkp@contoso.com"
$mailserver = "mail.contoso.com"
$smtpport=587
$emailsubject = "VM Full backup  - VEEAMZIP Weekly report"

Find-VBRHvEntity -server $hyperv_node -name $vm_name

#Or list the all the VMs
Get-VBRServer -Name $hyperv_node | Find-VBRHvEntity

#Compress with VeeamZip
Start-VBRZip -Folder $nas -Entity $vm -Compression 4 -DisableQuiesce -AutoDelete In2Weeks -NetworkCredentials $vmm_cred -RunAsync

#These week Backups
$BACKUP_SUMMARY = Get-ChildItem $nas | Select-Object NAME, LastWriteTime,  @{N='SizeInGB';E={[math]::Round($_.length / 1GB,2)}} | Where-Object {$_.LASTWRITETIME -gt $(Get-Date).ADDdAYS(-7) } | ConvertTo-Html

#Send an email
Send-MailMessage  -subject $emailsubject -BodyAsHtml "$BACKUP_SUMMARY" -From $email_notify_from -to $email_notify_to -SmtpServer $mailserver -port $smtpport

