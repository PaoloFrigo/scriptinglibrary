#Requires -Version 7

# THIS SCRIPT COMPARES SERIAL AND PARALLEL EXECUTION OF A FOREACH LOOP
# Paolo Frigo, https://www.scriptinglibrary.com

Write-Output "Serial Execution of 10 tasks of 1 seconds"
Measure-Command -expression {1..10 | foreach-object {Start-Sleep -seconds 1}}

Write-Output "Parallel Execution of 10 tasks of 1 seconds "
Measure-Command -expression {1..10 | foreach-object -parallel {Start-Sleep -seconds 1}}

#Setting Throttlelimit to 10 instead 5 (default value)
#Interesting blog article from Paul Higinbotham : https://devblogs.microsoft.com/powershell/powershell-foreach-object-parallel-feature/
Write-Output "Parallel Execution (throttlelimit = 10 ) of 10 tasks of 1 seconds"
Measure-Command -expression {1..10 | foreach-object -parallel {Start-Sleep -seconds 1} -throttlelimit 10}
 