REM Paolo Frigo, https://www.scriptinglibrary.com 

REM THIS SCRIPTS REDIRECTS SYSTEMINFO AND IPCONFIG OUTPUT TO A FILE

SET /p DESC="Enter a suffix, e.g. PRE-UPGRADE: "
SET OUTPUTFILE="D:\%COMPUTERNAME%-%DESC%.TXT

systeminfo > %OUTPUTFILE%
ipconfig /all >> %OUTPUTFILE%

echo "%OUTPUTFILE% file written"