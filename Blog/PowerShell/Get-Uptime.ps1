#
#   Paolo Frigo, www.scriptinglibrary.com
#
Get-CimInstance -ClassName win32_operatingsystem | Select-Object -ExpandProperty LastBootUpTime