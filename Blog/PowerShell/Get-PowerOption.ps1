#Requires -RunAsAdministrator

function Get-PowerOption{
    <#
      .Synopsis
          Get the power option of a host.

      .Description
          Get the power option of a host.

      .Example
          PS C:\Windows\system32> Get-PowerOption box1

          WARNING: *** Starting WinRM service on box1

          Existing Power Schemes (* Active)
          -----------------------------------
          Power Scheme GUID: 381b4222-f694-41f0-9685-ff5bb260df2e  (Balanced)
          Power Scheme GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  (High performance) *
          Power Scheme GUID: a1841308-3541-4fab-bc81-f71556f20b4a  (Power saver)
          Power Scheme GUID: db310065-829b-4671-9647-2261c00e86ef  (High Performance (ConfigMgr))
          WARNING: *** Stopping WinRM service on box1
     .Example
          get-adcomputer -searchbase ‘OU=Computers,dc=contoso,dc=com’ -filter * -property * | select-object name  | Get-PowerOption

          Get-PowerOption for all the workstations in AD.

      .Notes
            Author: Paolo Frigo - https://www.scriptinglibrary.com
   #>
  Param(
      [Parameter(Mandatory=$true,
      ValueFromPipeline=$true,
      ValueFromPipelineByPropertyName=$true,
      Position=0)]
      [Alias('name')]

      [string[]]$ComputerName
      )
  process{
      $winRmNotRunning =(Get-Service -ComputerName $ComputerName winrm).Status -eq "Stopped"
      if ($winRmNotRunning -eq "True"){
          Get-Service -ComputerName $ComputerName winrm | Start-Service
          Write-Warning "*** Starting WinRM service on $ComputerName"
      }
      $RemoteSession = New-PSSession -ComputerName $ComputerName
      invoke-command -Session $RemoteSession -ScriptBlock { powercfg /l }
      Get-Service -ComputerName $ComputerName winrm | Stop-Service
      Write-Warning "*** Stopping WinRM service on $ComputerName"
      Remove-PSSession -Session $RemoteSession
  }
}
