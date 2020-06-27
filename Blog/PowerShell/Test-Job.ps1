# THIS SCRIPT TEST PARALLEL EXECUTION USING JOBS
# Paolo Frigo, https://www.scriptinglibrary.com

$ServerList = "www.google.com", "www.bing.com", "www.yahoo.com"

#CLEAR THE JOB LIST
Get-Job | Remove-Job 

#START A LIST OF JOBS
$ServerList | Foreach-object {Start-job -name "$_" -scriptblock {param ($Target) Test-connection -computername $Target -count 1} -argumentlist $_}

# Note that Job States are: RUNNING, COMPLETED, FAILED
# WAITS FOR ALL JOBS TO COMPLETE UP TO THE TIMEOUT LIMIT
# PREVENTING THE SCRIPT TO RUN FOREVER
$Timeout = 60 #seconds
$Counter = 0
do{Start-sleep -seconds 1; $Counter+=1} while( (Get-Job).state -contains "Running" -and $Timeout -gt $counter)

#GET ALL THE RESULTS WITH KEEP (WITHOUT DELETING THEM)
$ServerList | Foreach-object {Receive-Job -name $_ -keep} 

#CLEAR THE JOB LIST 
Get-Job | Remove-Job  #this step is not required if KEEP flag is removed.