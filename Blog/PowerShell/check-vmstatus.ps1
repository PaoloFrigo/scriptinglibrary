#requires -module hyper-v

#Paolo Frigo, https://www.scriptinglibrary.com

foreach ($i in $(Get-VM)){
    if ($i.status  -ne "Operating normally"){
        Write-Output "$i.name - $i.staus"
        exit 2 
    }    
}
Write-Output "All VMs are Operating normally"
exit 0