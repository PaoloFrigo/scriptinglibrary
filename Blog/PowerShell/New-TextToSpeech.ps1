#Paolo Frigo, https://www.scriptinglibrary.com

# This is just an simple Text To Speech Example

Add-Type –AssemblyName System.Speech
$SpeechSynthesizer = New-Object –TypeName System.Speech.Synthesis.SpeechSynthesizer
#$SpeechSynthesizer.SelectVoice("Microsoft Zira Desktop")
$SpeechSynthesizer.Speak($Text)

# To List of installed voices
#Foreach ($voice in $SpeechSynthesizer.GetInstalledVoices()){
#    $Voice.VoiceInfo | Select-Object Gender, Name, Culture, Description
#}
