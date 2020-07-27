#Paolo Frigo, https://www.scriptinglibrary.com

$StringFrequencyList	= 82, 110, 146, 196, 246, 329       # E,A,D,G,B,E
$Duration 				= 4000 								# milliseconds 

$StringFrequencyList | Foreach-Object {[console]::beep($_,$Duration)}