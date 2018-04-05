# Deployment Example
The aim of this deployment project is summarize in a single example some tips and suggestions published on https://www.scriptinglibrary.com

This deployment script shows some of the benefits of _decoupling settings from the script itself_, in fact all the settings are stored in a single JSON file in the config folder.

Scripts can be _signed_ and _executed with even the most restrictive execution policies_, if we need to re-use script in different environments (PROD, TEST) or add/remove artefacts we can modify the JSON File without altering a single line of the script.

_Splitting_ the deployment file and importing all other sections with _dot-sourcing_ makes the script easier to read and to maintain. 

Using _Pester_ and writing some _Unit and Integration tests_ for TEST environment task of creating a subfolder offers the opportunity of checking the _code coverage of 100%_ of our source code.
~~~~ 
PS D:\Paolo\Git\Blog\PowerShell\Deployment\lib> Invoke-Pester .\New-SubFolderWithDate.Test.ps1 -CodeCoverage .\New-SubFo
lderWithDate.ps1


Describing New-SubFolderWithDate Unit-Tests
 [+] Should throw an error when the folder already exists 1.95s
 [+] Should throw an error when fails to create a folder 485ms
Describing New-SubFolderWithDate Integration-Tests
 [+] Should create the folder 331ms
Tests completed in 2.77s
Passed: 3 Failed: 0 Skipped: 0 Pending: 0 Inconclusive: 0

Code coverage report:
Covered 100,00% of 7 analyzed commands in 1 file.
~~~~ 
In brief, this deployment script should prompt the Environment, Project and version that will be deployed and the status of the artifact download in this case from a git repository (without using posh-git).

Output :
~~~~ 
PS D:\Paolo\Git\Blog\PowerShell\Deployment> .\Deployment.ps1
[PROD] MyPlayground - Version: 1.0.0
Artefact Downloaded : Proxy Functions, Latest Release
Artefact Downloaded : Set-HighPerformance, Latest Release
~~~~ 