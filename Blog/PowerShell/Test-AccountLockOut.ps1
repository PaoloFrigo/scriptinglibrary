#Paolo Frigo, scriptinglibrary.com
#requires -runasadministrator
#requires -module ActiveDirectory

#how to test ad account lockout policies

#create a test user
New-aduser -name "test-user"

#let's check the user created
Get-ADUser test-user

<#
DistinguishedName : CN=test-user,CN=Users,DC=contoso,DC=com
Enabled           : False
GivenName         :
Name              : test-user
ObjectClass       : user
ObjectGUID        : 8353f6f5-2a3d-4096-a021-a430e3f257cc
SamAccountName    : test-user
SID               : S-1-5-21-3655427247-682778731-3851803015-1103
Surname           :
UserPrincipalName :
#>

#Reset the password for this user:
Get-ADUser test-user | Set-ADAccountPassword
<#
Please enter the current password for 'CN=test-user,CN=Users,DC=contoso,DC=com'
Password:
Please enter the desired password for 'CN=test-user,CN=Users,DC=contoso,DC=com'
Password: *********
Repeat Password: *********
#>

#Let's enable our test account
Get-ADUser test-user | Enable-ADAccount

#let's check the  AD default domain password policies
Get-ADDefaultDomainPasswordPolicy

<#
ComplexityEnabled           : True
DistinguishedName           : DC=contoso,DC=com
LockoutDuration             : 00:30:00
LockoutObservationWindow    : 00:30:00
LockoutThreshold            : 5
MaxPasswordAge              : 42.00:00:00
MinPasswordAge              : 1.00:00:00
MinPasswordLength           : 7
objectClass                 : {domainDNS}
objectGuid                  : dfc165e9-bbf7-46a3-82c8-6eecac1e2496
PasswordHistoryCount        : 24
ReversibleEncryptionEnabled : False
#>

#let's double check our user before staring to test
Get-ADUser test-user -properties LockedOut, LastBadPasswordAttempt
<#
DistinguishedName      : CN=test-user,CN=Users,DC=contoso,DC=com
Enabled                : True
GivenName              :
LastBadPasswordAttempt : 1/11/2018 11:37:45 PM
LockedOut              : False
Name                   : test-user
ObjectClass            : user
ObjectGUID             : 8353f6f5-2a3d-4096-a021-a430e3f257cc
SamAccountName         : test-user
SID                    : S-1-5-21-3655427247-682778731-3851803015-1103
Surname                :
UserPrincipalName      :
#>

#Let's make 5 wrong authentication attempts to lockout the test user
(1..5)| ForEach-Object{runas /user:contoso\test-user cmd}
<#
Enter the password for contoso\test-user:
Attempting to start cmd as user "contoso\test-user" ...
RUNAS ERROR: Unable to run - cmd
1326: The user name or password is incorrect.
 Enter the password for contoso\test-user:
Attempting to start cmd as user "contoso\test-user" ...
RUNAS ERROR: Unable to run - cmd
1326: The user name or password is incorrect.
 Enter the password for contoso\test-user:
Attempting to start cmd as user "contoso\test-user" ...
RUNAS ERROR: Unable to run - cmd
1909: The referenced account is currently locked out and may not be logged on to.
 Enter the password for contoso\test-user:
Attempting to start cmd as user "contoso\test-user" ...
RUNAS ERROR: Unable to run - cmd
1909: The referenced account is currently locked out and may not be logged on to.
 Enter the password for contoso\test-user:
Attempting to start cmd as user "contoso\test-user" ...
RUNAS ERROR: Unable to run - cmd
1909: The referenced account is currently locked out and may not be logged on to.
#>


#let's check our user
Get-ADUser test-user -properties LockedOut, LastBadPasswordAttempt

<#
DistinguishedName      : CN=test-user,CN=Users,DC=contoso,DC=com
Enabled                : True
GivenName              :
LastBadPasswordAttempt : 1/11/2018 11:59:00 PM
LockedOut              : True
Name                   : test-user
ObjectClass            : user
ObjectGUID             : 8353f6f5-2a3d-4096-a021-a430e3f257cc
SamAccountName         : test-user
SID                    : S-1-5-21-3655427247-682778731-3851803015-1103
Surname                :
UserPrincipalName      :
#>

#search for locked out accounts
Search-ADAccount -LockedOut
<#
AccountExpirationDate :
DistinguishedName     : CN=test-user,CN=Users,DC=contoso,DC=com
Enabled               : True
LastLogonDate         :
LockedOut             : True
Name                  : test-user
ObjectClass           : user
ObjectGUID            : 8353f6f5-2a3d-4096-a021-a430e3f257cc
PasswordExpired       : False
PasswordNeverExpires  : False
SamAccountName        : test-user
SID                   : S-1-5-21-3655427247-682778731-3851803015-1103
UserPrincipalName     :
#>


#investigate on specific user
Get-ADUser -Filter {DisplayName -like "John D*"}  -Properties PasswordExpired, PasswordLastSet, EmailADdress,BadLogonCount,lastbadpasswordattempt, Lastlogondate, LockedOut, LockoutTime


Get-EventLog -LogName Security -ComputerName $(Get-ADDomainController).hostname -InstanceId 4740 -newest 5
<#
   Index Time          EntryType   Source                 InstanceID Message
   ----- ----          ---------   ------                 ---------- -------
   13236 Nov 01 23:59  SuccessA... Microsoft-Windows...         4740 A user account was locked out....
#>


#Let's search for the caller ID
Get-EventLog -LogName Security -ComputerName $(Get-ADDomainController).hostname -InstanceId 4740 -newest 1 | Select-Object -exp Message
<#
A user account was locked out.

Subject:
        Security ID:            S-1-5-18
        Account Name:           MYDC$
        Account Domain:         CONTOSO
        Logon ID:               0x3e7

Account That Was Locked Out:
        Security ID:            S-1-5-21-3655427247-682778731-3851803015-1103
        Account Name:           test-user

Additional Information:
        Caller Computer Name:   MYDC
#>

#Let's close this test by disabling the test-account
Disable-ADAccount test-user