rem Paolo Frigo, https://scriptinglibrary.com
rem Refresh kerberos tickets without requiring logoff or reboot

rem To check the result before and after you can use either of these two options:
rem gpresult /r   
rem whoami /groups

rem  klist.exe tool is refreshing the kerberos tickets (From Win 7 / Windows Server 2003)
klist -li 0:0x3e7 purge