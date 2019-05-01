#
#   Paolo Frigo, www.scriptinglibrary.com
#

function Test-ADCredential([SecureString] $cred) {
    try {
        start-process 'cmd' -Credential $cred
        $auth_success = [bool](Get-Process 'cmd' -IncludeUserName | Select-Object id, username, processname )
        if ($auth_success -eq $true) {
            Get-Process 'cmd' -IncludeUserName | Where-Object {$_.username -eq "$($cred.Username)" } | Stop-Process -Force
            Write-OutPut "Autentication succedeed for $($cred.Username)"
        }
    }
    catch {
        Write-Error "Authentication Failed for $($cred.Username)"
    }
}
Test-ADCredential($(Get-Credential))