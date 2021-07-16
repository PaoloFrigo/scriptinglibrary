Rem Paolo Frigo, https://scriptinglibrary.com

Rem The original author of this snippet is CRAIG SCHELLENBERG
Rem https://www.sikich.com/insight/how-to-perform-file-server-migrations-using-robocopy-part-1/

Rem REPLACE
Rem <SOURCE>, <DESTINATION> AND <LOGNAME> LOGNAME_%date:~-10,2%"-"%date:~7,2%"-"%date:~-4,4%.txt

robocopy <SOURCE> <DESTINATION> /e /b /copyall /PURGE /r:5 /w:5 /MT:64 /tee /log+:<LOGNAME> /v

